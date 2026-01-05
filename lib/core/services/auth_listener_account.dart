import 'package:firebase_auth/firebase_auth.dart';

class AuthListener {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة لتشغيل المراقبة
  void startListening() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
}