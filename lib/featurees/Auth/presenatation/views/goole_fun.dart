import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// تسجيل الدخول بجوجل
/// [forceSignOut] = true → يظهر اختيار الحساب دائمًا.
/// [forceSignOut] = false → يستخدم الحساب الحالي إذا موجود.
Future<UserCredential?> signInWithGoogle({bool forceSignOut = false}) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  try {
    // إذا المستخدم طلب تغيير الحساب → نفصل الحساب القديم نهائيًا
    if (forceSignOut) {
      try {
        await googleSignIn.disconnect();
      } catch (_) {
        print("لا يوجد حساب متصل مسبقاً");
      }
    }

    // بدء تسجيل الدخول
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print("تم إلغاء تسجيل الدخول");
      return null;
    }

    // جلب التوكنات
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // إنشاء credential لـ Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // تسجيل الدخول
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    print("تم تسجيل الدخول: ${userCredential.user?.email}");
    return userCredential;
  } catch (e) {
    print("حصل خطأ أثناء تسجيل الدخول: $e");
    return null;
  }
}
