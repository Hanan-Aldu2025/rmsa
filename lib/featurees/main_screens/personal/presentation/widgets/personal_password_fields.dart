// lib/featurees/main_screens/personal/presentation/views/widgets/personal_password_fields.dart

import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_text_field.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';

/// حقول كلمة المرور (القديمة والجديدة)
class PersonalPasswordFields extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;

  const PersonalPasswordFields({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return Column(
      children: [
        // كلمة المرور القديمة
        PersonalTextField(
          controller: oldPasswordController,
          label: lang.oldPassword,
          icon: Icons.lock_open_outlined,
          isPassword: true,
        ),

        const SizedBox(height: 15),

        // كلمة المرور الجديدة
        PersonalTextField(
          controller: newPasswordController,
          label: lang.newPassword,
          icon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }
}
