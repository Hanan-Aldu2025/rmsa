import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationChecker extends StatefulWidget {
  static const routeName = "/verify-email";

  const EmailVerificationChecker({super.key});

  @override
  State<EmailVerificationChecker> createState() =>
      _EmailVerificationCheckerState();
}

class _EmailVerificationCheckerState extends State<EmailVerificationChecker> {
  bool _loading = false;

  Future<void> _checkVerification() async {
    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() => _loading = false);
        return;
      }

      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser!.emailVerified) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ تم التحقق من بريدك الإلكتروني!"),
            duration: Duration(seconds: 2),
          ),
        );

        // الانتقال للهوم
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, "/home");
        });
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ لم يتم التحقق بعد. الرجاء فحص بريدك."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-token-expired") {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      }
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحقق من بريدك"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 80),
            const SizedBox(height: 20),

            const Text(
              "تم إرسال رابط التحقق إلى بريدك الإلكتروني.\n"
              "بعد فتح الرابط، اضغطي على الزر بالأسفل.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _checkVerification,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "تحقق مرة أخرى",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("📩 تم إرسال رابط التحقق مرة أخرى."),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("إعادة إرسال رابط التحقق"),
            ),
          ],
        ),
      ),
    );
  }
}
