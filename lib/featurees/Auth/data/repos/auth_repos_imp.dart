import 'package:appp/core/error/Custom_Exception.dart';
import 'package:appp/core/error/failure.dart';
import 'package:appp/core/services/firebase_auth_services.dart';
import 'package:appp/featurees/Auth/data/models/user_model.dart';
import 'package:appp/featurees/Auth/domain/entity/user_entity.dart';
import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthReposImp implements AuthRepos {
  final FirebaseAuthServices firebaseAuthServices;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthReposImp(this.firebaseAuthServices);

  // ================= إنشاء مستخدم جديد =================
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String? email,
    String password,
    String name, {
    required String phoneNumber,
    required bool verifyEmail,
  }) async {
    try {
      User user;

      if (email != null && email.isNotEmpty) {
        // تحقق من صحة البريد
        final emailRegex =
            RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        if (!emailRegex.hasMatch(email)) {
          return Left(FailureServer("البريد غير صالح"));
        }

        // إنشاء مستخدم على Firebase
        user = await firebaseAuthServices.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (verifyEmail) await user.sendEmailVerification();
      } else {
        // البريد فارغ → placeholder للبريد
        user = await firebaseAuthServices.createUserWithEmailAndPassword(
          email: "placeholder_${phoneNumber}@yourapp.com",
          password: password,
        );
      }

      final userEntity = UserModel.fromFirebaseUser(user, phoneNumber: phoneNumber);
      return Right(userEntity);
    } catch (e) {
      return Left(FailureServer('فشل إنشاء المستخدم: ${e.toString()}'));
    }
  }

  // ================= حفظ البيانات بعد التحقق =================
  @override
  Future<void> saveUserToFirestore(
    User user, {
    required String name,
    required String phoneNumber,
    String? email,
  }) async {
    final userData = {
      "created_at": Timestamp.now(),
      "email_verified": user.emailVerified,
      "phone_number": phoneNumber,
      "phone_verified": false,
      "profile_image": "",
      "user_email": email ?? "",
      "user_id": user.uid,
      "user_name": name,
    };

    await firestore.collection("user_information").doc(user.uid).set(userData);
  }

  // ================= التحقق من البريد =================
  @override
  Future<bool> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    await user.reload();
    return user.emailVerified;
  }

  // ================= الهاتف + OTP (معلق مؤقت) =================
  // @override
  // Future<Either<Failure, String>> sendOtp({required String phoneNumber}) async {
  //   // 🔹 للتفعيل لاحقًا: أرسل OTP على الهاتف
  //   // throw UnimplementedError();
  //   return Right("otp_verification_id_placeholder"); // مؤقت
  // }

  // @override
  // Future<Either<Failure, UserEntity>> verifyOtp({
  //   required String smsCode,
  //   required String verificationId,
  // }) async {
  //   // 🔹 للتفعيل لاحقًا: تحقق من OTP مع Firebase
  //   // throw UnimplementedError();
  //   return Left(FailureServer("verifyOtp not implemented yet"));
  // }

  // ================= تسجيل الدخول بالبريد =================
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailOrPhone(
      String input, String password) async {
    try {
      final isEmail = input.contains('@');
      String emailToUse = input;

      if (!isEmail) {
        // 🔹 لاحقًا نبحث البريد المرتبط بالهاتف
        final querySnapshot = await firestore
            .collection("user_information")
            .where('phone_number', isEqualTo: input)
            .get();

        if (querySnapshot.docs.isEmpty) {
          return Left(FailureServer('رقم الهاتف غير موجود'));
        }

emailToUse = querySnapshot.docs.first.data()['user_email'] ?? '';
        if (emailToUse.isEmpty) {
          return Left(FailureServer('لم يتم ربط البريد برقم الهاتف'));
        }
      }

      final user =
          await firebaseAuthServices.signInWithEmailOrPhone(input: emailToUse, password: password);

      final doc =
          await firestore.collection("user_information").doc(user.uid).get();
      final phoneNumber = doc.data()?['phone_number'] ?? '';

      final userEntity = UserModel.fromFirebaseUser(user, phoneNumber: phoneNumber);
      return Right(userEntity);
    } catch (e) {
      return Left(FailureServer('فشل تسجيل الدخول: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(String email, String password) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, UserEntity>> verifyOtp({required String smsCode, required String verificationId}) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
}