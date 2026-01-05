import 'package:appp/core/error/Custom_Exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================== إنشاء حساب ==================
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    bool verifyEmail = false, // ✅ إضافة verifyEmail هنا
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // إذا كان التحقق من البريد مطلوبًا، أرسل رابط التفعيل
      if (verifyEmail) {
        await user.sendEmailVerification(); // ✅ إرسال رابط التفعيل للبريد
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException(message: "كلمة المرور ضعيفة جدًا");
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(message: 'هذا البريد مستخدم من قبل');
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: "صيغة البريد غير صحيحة");
      } else {
        throw CustomException(message: 'حدث خطأ، حاول لاحقًا');
      }
    } catch (e) {
      throw CustomException(message: 'حدث خطأ غير متوقع، حاول لاحقًا');
    }
  }

  // ================== التحقق من صحة البريد الإلكتروني ==================
  // التحقق من البريد الإلكتروني
  Future<bool> isEmailValid(String email) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url:
            'https://yourapp.page.link/verifyEmail?email=$email', // الرابط الذي سيتم توجيه المستخدم إليه بعد التحقق
        handleCodeInApp:
            true, // تأكد من أن الرابط سيتعامل معه داخل التطبيق وليس على المتصفح
      );

      // إرسال الرابط إلى البريد الإلكتروني للتحقق منه
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      return true; // إذا تم إرسال الرابط بنجاح، البريد صالح
    } catch (e) {
      // في حالة حدوث خطأ (مثل أن البريد غير صالح أو وهمي)
      return false; // البريد غير صالح
    }
  }

  // ================== تسجيل الدخول ==================
  Future<User> signInWithEmailOrPhone({
    required String input, // البريد الإلكتروني أو رقم الهاتف
    required String password,
  }) async {
    try {
      // 1- التحقق إذا المدخل بريد إلكتروني أو رقم هاتف
      final isEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(input);

      User? user;

      if (isEmail) {
        // تسجيل الدخول بالبريد الإلكتروني
        final credential = await _auth.signInWithEmailAndPassword(
          email: input,
          password: password,
        );
        user = credential.user;
      } else {
        // تسجيل الدخول برقم الهاتف
        // هنا Firebase لا يدعم تسجيل الدخول بالرقم مباشرة مع كلمة المرور،
        // عادةً يستخدم OTP. لكن إذا خزنت رقم الهاتف مسبقًا وربطته بالبريد،
        // يمكننا تحويل الرقم لبريد مؤقت أو البحث في قاعدة البيانات.
        throw CustomException(
          message: "تسجيل الدخول بالرقم غير مدعوم مباشرة، استخدم OTP",
        );
      }

      if (user == null) {
        throw CustomException(message: "فشل تسجيل الدخول");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException(message: "المستخدم غير موجود");
      } else if (e.code == 'wrong-password') {
        throw CustomException(message: "كلمة المرور غير صحيحة");
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: "البريد الإلكتروني غير صالح");
      } else {
        throw CustomException(message: "حدث خطأ، حاول لاحقًا");
      }
    }
  }

  // ================== إعادة تعيين كلمة المرور ==================
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
//=========================================================================================
  // فتح رابط إعادة التعيين في المتصفح (اختياري)
  Future<void> openResetPasswordLink(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://yourapp.page.link/resetPassword?email=$email',
      handleCodeInApp: true,
      androidPackageName: 'com.yourcompany.yourapp',
      iOSBundleId: 'com.yourcompany.yourapp',
    );

    await _auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );

    final url = Uri.parse(
      'https://yourapp.page.link/resetPassword?email=$email',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


//====================================================================================================================//
