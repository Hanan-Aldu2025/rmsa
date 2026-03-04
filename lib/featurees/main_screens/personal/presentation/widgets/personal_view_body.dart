// lib/featurees/main_screens/personal/presentation/views/personal_view_body.dart

import 'package:appp/featurees/main_screens/personal/presentation/cubit/personal_cubit.dart';
import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_action_buttons.dart';
import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_header_icon.dart';
import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_password_fields.dart';
import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_text_field.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// /// جسم صفحة البيانات الشخصية

class PersonalViewBody extends StatelessWidget {
  final bool isEditing;

  const PersonalViewBody({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalCubit>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // أيقونة الرأس
            const PersonalHeaderIcon(),

            const SizedBox(height: 30),

            // حقول الإدخال الأساسية
            PersonalTextField(
              enabled: isEditing,
              controller: cubit.nameController,
              label: S.of(context).userName,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 15),

            PersonalTextField(
              enabled: isEditing,
              controller: cubit.phoneController,
              label: S.of(context).phone,
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 15),

            PersonalTextField(
              enabled: isEditing,
              controller: cubit.emailController,
              label: S.of(context).email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            // حقول كلمة المرور (تظهر فقط في وضع التعديل)
            if (isEditing) ...[
              const SizedBox(height: 15),
              PersonalPasswordFields(
                oldPasswordController: cubit.oldPasswordController,
                newPasswordController: cubit.newPasswordController,
              ),
            ],

            const SizedBox(height: 40),

            // أزرار الإجراءات
            PersonalActionButtons(
              isEditing: isEditing,
              onEditPressed: cubit.toggleEditing,
              onSavePressed: cubit.updateProfile,
              onCancelPressed: cubit.cancelEditing,
            ),
          ],
        ),
      ),
    );
  }
}
