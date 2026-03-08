import 'package:appp/featurees/Auth/data/models/User_Model.dart';
import 'package:appp/featurees/Auth/domain/entity/user_entity.dart';
import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepos authRepos;
  final BuildContext context;

  SignupCubit(this.authRepos, this.context) : super(SignupInitial());

  String? _verificationId;

  // ================= التحقق من البريد =================
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return emailRegex.hasMatch(email);
  }

  // ================= إنشاء الحساب بالبريد =================
  Future<void> signupWithEmail({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    emit(SignupLoading());

    try {
      // تحقق من الرقم
      // if (phoneNumber.isEmpty) {
      //   emit(SignupFailure(message: "رقم الهاتف إلزامي"));
      //   return;
      // }

      final result = await authRepos.createUserWithEmailAndPassword(
        email,
        password,
        name,
        phoneNumber: phoneNumber,
        verifyEmail: true,
      );

      result.fold(
        (failure) async {
          if (failure.errorMessage.contains('مستخدم')) {
            // البريد موجود مسبقًا
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              // تحقق من وجود البيانات في Firestore
              final doc = await FirebaseFirestore.instance
                  .collection("user_information")
                  .doc(user.uid)
                  .get();

              if (!doc.exists) {
                // لم تكن موجودة → نحفظها
                await authRepos.saveUserToFirestore(
                  user,
                  name: name,
                  phoneNumber: phoneNumber,
                  email: email,
                );
              }

              final userEntity = UserModel.fromFirebaseUser(
                user,
                phoneNumber: phoneNumber,
              );

              emit(SignupEmailAlreadyExists(userEntity: userEntity));

              // الانتقال مباشرة لصفحة المنتجات
              Navigator.pushReplacementNamed(context, '/products');
            } else {
              emit(SignupFailure(message: failure.errorMessage));
            }
          } else {
            emit(SignupFailure(message: failure.errorMessage));
          }
        },
        (user) async {
          // البريد جديد → نحفظه
          final firebaseUser = FirebaseAuth.instance.currentUser;
if (firebaseUser != null) {
  await authRepos.saveUserToFirestore(
    firebaseUser,   // 🔹 هنا لازم يكون User وليس UserEntity
    name: name,
    phoneNumber: phoneNumber,
    email: email,
  );
}
          emit(SignupEmailNotVerified(userEntity: user));

          // يمكنك هنا أن تظهر Snackbar تطلب من المستخدم التحقق من البريد
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تحقق من بريدك لتفعيل الحساب!")),
          );
        },
      );
    } catch (e) {
      emit(SignupFailure(message: "حدث خطأ غير متوقع"));
    }
  }

  // ================= التحقق من البريد بعد الضغط على الرابط =================
  Future<void> checkEmailVerified({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    emit(SignupLoading());

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      await firebaseUser?.reload(); // تحديث حالة البريد

      if (firebaseUser != null && firebaseUser.emailVerified) {
        // البريد تحقق → حفظ البيانات في Firestore
        await authRepos.saveUserToFirestore(
          firebaseUser,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
        );

final updatedUser = UserModel.fromFirebaseUser(
          firebaseUser,
          phoneNumber: phoneNumber,
        );

        emit(SignupSuccese(userEntity: updatedUser));

        // الانتقال لصفحة المنتجات
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        emit(SignupEmailNotVerified(
          userEntity: UserModel.fromFirebaseUser(
            firebaseUser!,
            phoneNumber: phoneNumber,
          ),
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("البريد لم يتم التحقق منه بعد")),
        );
      }
    } catch (e) {
      emit(SignupFailure(message: "حدث خطأ أثناء التحقق من البريد"));
    }
  }

  // ================= الهاتف جاهز للتفعيل لاحقًا =================
  Future<void> sendOtpToPhone(String phoneNumber, {String? email}) async {
    emit(SignupLoading());

    if (email != null && !isValidEmail(email)) {
      emit(SignupFailure(message: "البريد غير صالح"));
      return;
    }

    try {
      final normalizedPhone = normalizePhone(phoneNumber);

      // 🔹 مؤقتًا: تعليق الهاتف لأن الخدمة مدفوعة
      // final result = await authRepos.sendOtp(phoneNumber: normalizedPhone);
      // result.fold(
      //   (failure) => emit(SignupFailure(message: failure.errorMessage)),
      //   (verificationId) {
      //     _verificationId = verificationId;
      //     emit(SignupOtpSent());
      //   },
      // );

    } catch (e) {
      emit(SignupFailure(message: e.toString()));
    }
  }

  String normalizePhone(String phone) {
    phone = phone.replaceAll(' ', '');
    if (phone.startsWith('00')) {
      phone = '+' + phone.substring(2);
    }
    if (!phone.startsWith('+')) {
      throw Exception('Phone number must start with +');
    }
    return phone;
  }

  Future<void> verifyOtpCode(String smsCode) async {
    if (_verificationId == null) {
      emit(SignupFailure(message: 'Verification ID is missing'));
      return;
    }

    emit(SignupLoading());

    // 🔹 مؤقتًا: تعليق الهاتف لأن الخدمة مدفوعة
    // final result = await authRepos.verifyOtp(
    //   smsCode: smsCode,
    //   verificationId: _verificationId!,
    // );
    //
    // result.fold(
    //   (failure) => emit(SignupFailure(message: failure.errorMessage)),
    //   (user) => emit(SignupSuccese(userEntity: user)),
    // );
  }
}