import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/Auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepos {
  // ================= إنشاء مستخدم جديد =================
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String? email,
    String password,
    String name, {
    required String phoneNumber, // الهاتف إلزامي
    required bool verifyEmail,   // تحقق البريد
  });

  // ================= تسجيل الدخول بالبريد فقط =================
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  // ================= تسجيل الدخول بالبريد أو الهاتف =================
  Future<Either<Failure, UserEntity>> signInWithEmailOrPhone(
    String input, // إيميل أو رقم هاتف
    String password,
  );

  // ================= الهاتف + OTP (معلق مؤقت) =================
  // Future<Either<Failure, String>> sendOtp({required String phoneNumber}); // 🔹 لاحقًا تفعيل

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String smsCode,
    required String verificationId,
  }); // 🔹 لاحقًا تفعيل

  // ================= إعادة تعيين كلمة المرور =================
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  // ================= حفظ المستخدم بعد التحقق من البريد (والهاتف لاحقًا) =================
  Future<void> saveUserToFirestore(
    User user, { // المستخدم النهائي من FirebaseAuth
    required String name,
    required String phoneNumber,
    String? email,
  });

  // ================= التحقق من البريد بعد الضغط على الرابط =================
  Future<bool> checkEmailVerified(); // هذا لتسهيل Cubit
}