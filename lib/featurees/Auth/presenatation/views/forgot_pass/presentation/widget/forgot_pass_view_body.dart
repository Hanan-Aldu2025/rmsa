import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/forgot_pass_cubit/forgotpass_cubit.dart';
import 'package:appp/generated/l10n.dart'; // ملف الترجمة المولد

class ForgotPasswordBody extends StatelessWidget {
  final TextEditingController emailController;

  const ForgotPasswordBody({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // عنوان الصفحة
          Text(
            S.of(context).forgotPasswordTitle,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // حقل البريد الإلكتروني
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: S.of(context).emailLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // زر الإرسال
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  context.read<ForgotPasswordCubit>().sendResetEmail(email);
                } else {
                  // رسالة خطأ إذا الحقل فارغ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).emptyEmailError)),
                  );
                }
              },
              child: Text(S.of(context).sendResetEmail),
            ),
          ),
        ],
      ),
    );
  }
}
