import 'dart:math';

import 'package:appp/featurees/Auth/data/models/User_Model.dart';
import 'package:appp/featurees/Auth/domain/entity/user_entity.dart';
import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepos authRepos;
  final BuildContext context;

  SignupCubit(this.authRepos, this.context) : super(SignupInitial());

  String? _verificationId;

  String? _generatedOtp; // الكود الذي سنولده
  // 1. دالة توليد الكود وفتح الواتساب
  // Future<void> sendOtpToWhatsapp(String inputPhoneNumber) async {
  //   emit(SignupLoading());
  //   try {
  //     // 1. توليد الكود
  //     _generatedOtp = (Random().nextInt(900000) + 100000).toString();

  //     // 2. معالجة الرقم المدخل ديناميكياً
  //     // سنقوم بتنظيف الرقم من أي مسافات أو أصفار زائدة في البداية
  //     String cleanPhone = inputPhoneNumber.trim().replaceAll(' ', '');

  //     // إذا بدأ المستخدم بـ 00 نحذفها ونضع رمز الدولة (للواتساب)
  //     if (cleanPhone.startsWith('00')) cleanPhone = cleanPhone.substring(2);
  //     if (cleanPhone.startsWith('+')) cleanPhone = cleanPhone.substring(1);

  //     // ملاحظة: بما أنك تستهدف السعودية واليمن، يفضل التحقق من طول الرقم
  //     // إذا كان الرقم يمني (967) أو سعودي (966)
  //     String formattedPhone;
  //     if (cleanPhone.startsWith('967') || cleanPhone.startsWith('966')) {
  //       formattedPhone = cleanPhone;
  //     } else {
  //       // إذا أدخل المستخدم الرقم بدون رمز الدولة (مثل 717...) نفترض أنه يمني حالياً
  //       formattedPhone = "967$cleanPhone";
  //     }

  //     String message = "كود التحقق الخاص بك هو: $_generatedOtp";
  //     String url =
  //         "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}";

  //     if (await launchUrl(
  //       Uri.parse(url),
  //       mode: LaunchMode.externalApplication,
  //     )) {
  //       emit(SignupOtpSent());
  //     } else {
  //       emit(SignupFailure(message: "تعذر فتح الواتساب"));
  //     }
  //   } catch (e) {
  //     emit(SignupFailure(message: "خطأ في الإرسال"));
  //   }
  // }

  Future<void> sendOtpToWhatsapp(String inputPhone) async {
    emit(SignupLoading());
    try {
      // 1. تنظيف الرقم
      String phone = inputPhone.trim().replaceAll(' ', '').replaceAll('+', '');

      // 2. 🔥 التحقق من وجود الرقم في Firestore قبل أي خطوة
      final query = await FirebaseFirestore.instance
          .collection("user_information")
          .where('phone_number', isEqualTo: phone)
          .get();

      if (query.docs.isNotEmpty) {
        emit(
          SignupFailure(message: "رقم الهاتف موجود مسبقاً، يرجى تسجيل الدخول"),
        );
        return;
      }

      // 3. توليد الكود (كما فعلتِ سابقاً)
      _generatedOtp = (Random().nextInt(900000) + 100000).toString();

      // 4. تنسيق الرقم للواتساب (نفس منطقك)
      String formattedPhone = phone; // هنا منطق التنسيق الذي كتبتيه سابقاً...
      if (phone.startsWith('7'))
        formattedPhone = "967$phone";
      else if (phone.startsWith('05'))
        formattedPhone = "966${phone.substring(1)}";

      String message = "كود التحقق الخاص بك هو: $_generatedOtp";
      String whatsappUrl =
          "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}";

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
        emit(SignupOtpSent());
      } else {
        emit(SignupFailure(message: "تأكد من تثبيت واتساب"));
      }
    } catch (e) {
      emit(SignupFailure(message: "حدث خطأ غير متوقع"));
    }
  }

  // 5. 🔥 توحيد دالة التحقق وإتمام الحفظ
  Future<void> verifyOtpAndSignup({
    required String userEnteredOtp,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    if (userEnteredOtp == _generatedOtp) {
      emit(SignupLoading());
      try {
        // إكمال التسجيل في Firebase Auth
        final result = await authRepos.createUserWithEmailAndPassword(
          email,
          password,
          name,
          phoneNumber: phoneNumber,
          verifyEmail: false,
        );

        result.fold(
          (failure) => emit(SignupFailure(message: failure.errorMessage)),
          (userEntity) async {
            // 🔥 هنا التأكد من حفظ البيانات في Firestore يدوياً إذا لم يكن الـ Repo يقوم بذلك
            await authRepos.saveUserToFirestore(
              FirebaseAuth.instance.currentUser!,
              name: name,
              phoneNumber: phoneNumber,
              email: email,
            );
            emit(SignupSuccese(userEntity: userEntity));
          },
        );
      } catch (e) {
        emit(SignupFailure(message: "فشل إنشاء الحساب وحفظ البيانات"));
      }
    } else {
      emit(SignupFailure(message: "كود التحقق غير صحيح"));
    }
  }

  // Future<void> sendOtpToWhatsapp(String inputPhone) async {
  //   emit(SignupLoading());
  //   try {
  //     // 1. توليد كود عشوائي
  //     _generatedOtp = (Random().nextInt(900000) + 100000).toString();

  //     // 2. تنظيف وتنسيق الرقم
  //     String phone = inputPhone.trim().replaceAll(' ', '').replaceAll('+', '');

  //     String formattedPhone;

  //     if (phone.startsWith('7') && phone.length == 9) {
  //       // رقم يمني (بدون مفتاح) -> نضيف مفتاح اليمن
  //       formattedPhone = "967$phone";
  //     } else if (phone.startsWith('05') && phone.length == 10) {
  //       // رقم سعودي يبدأ بـ 05 -> نحول الصفر لمفتاح السعودية
  //       formattedPhone = "966${phone.substring(1)}";
  //     } else if (phone.startsWith('5') && phone.length == 9) {
  //       // رقم سعودي يبدأ بـ 5 مباشره
  //       formattedPhone = "966$phone";
  //     } else {
  //       // إذا أدخل الرقم بالمفتاح الدولي جاهز أو أي صيغة أخرى
  //       formattedPhone = phone;
  //     }

  //     // 3. تجهيز الرابط
  //     String message =
  //         "كود التحقق الخاص بك هو: $_generatedOtp \nيرجى نسخه والعودة للتطبيق لإتمام التسجيل.";
  //     String whatsappUrl =
  //         "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}";

  //     // 4. فتح الواتساب
  //     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
  //       await launchUrl(
  //         Uri.parse(whatsappUrl),
  //         mode: LaunchMode.externalApplication,
  //       );
  //       emit(
  //         SignupOtpSent(),
  //       ); // هذه الحالة ستظهر حقل إدخال الكود في واجهة المستخدم
  //     } else {
  //       emit(SignupFailure(message: "تأكد من تثبيت تطبيق واتساب على جهازك"));
  //     }
  //   } catch (e) {
  //     emit(SignupFailure(message: "فشل في فتح الواتساب"));
  //   }
  // }

  // دالة التحقق من الكود الذي أدخله المستخدم يدوياً
  void verifyOtpAndComplete(
    String enteredOtp, {
    required Map<String, dynamic> userData,
  }) {
    if (enteredOtp == _generatedOtp) {
      // الكود صحيح -> الآن نقوم بإنشاء الحساب في Firebase
      _finalizeSignup(userData);
    } else {
      emit(
        SignupFailure(
          message: "كود التحقق غير صحيح، يرجى التأكد من الكود المنسوخ",
        ),
      );
    }
  }

  Future<void> _finalizeSignup(Map<String, dynamic> data) async {
    emit(SignupLoading());
    // استدعاء دالة الـ Repo لإنشاء الحساب الفعلي
    final result = await authRepos.createUserWithEmailAndPassword(
      data['email'],
      data['password'],
      data['name'],
      phoneNumber: data['phone'],
      verifyEmail: false,
    );
    // ... معالجة النتيجة (نجاح أو فشل)
  }

  // 2. دالة التحقق من الكود وإتمام التسجيل
  Future<void> verifyAndSignup({
    required String userEnteredOtp,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    if (userEnteredOtp == _generatedOtp) {
      emit(SignupLoading());
      // الكود صح -> استدعِ دالة التسجيل الأصلية في Firebase
      final result = await authRepos.createUserWithEmailAndPassword(
        email,
        password,
        name,
        phoneNumber: phoneNumber,
        verifyEmail: false, // اجعلها false حالياً لتسهيل التجربة
      );

      result.fold(
        (failure) => emit(SignupFailure(message: failure.errorMessage)),
        (userEntity) => emit(SignupSuccese(userEntity: userEntity)),
      );
    } else {
      emit(SignupFailure(message: "كود التحقق غير صحيح، حاول مرة أخرى"));
    }
  }

  // ================= التحقق من البريد =================
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
    );
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
              firebaseUser, // 🔹 هنا لازم يكون User وليس UserEntity
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
        emit(
          SignupEmailNotVerified(
            userEntity: UserModel.fromFirebaseUser(
              firebaseUser!,
              phoneNumber: phoneNumber,
            ),
          ),
        );

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
