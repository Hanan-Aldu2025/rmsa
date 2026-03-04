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
// class PersonalViewBody extends StatefulWidget {
//   final Map<String, dynamic> initialData;

//   const PersonalViewBody({super.key, required this.initialData});

//   @override
//   State<PersonalViewBody> createState() => _PersonalViewBodyState();
// }

// class _PersonalViewBodyState extends State<PersonalViewBody> {
//   bool isEditing = false;

//   late final TextEditingController nameController;
//   late final TextEditingController phoneController;
//   late final TextEditingController emailController;
//   late final TextEditingController newPasswordController;
//   late final TextEditingController oldPasswordController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }

//   /// تهيئة المتحكمات
//   void _initializeControllers() {
//     nameController = TextEditingController(
//       text: widget.initialData['user_name'] ?? '',
//     );
//     phoneController = TextEditingController(
//       text: widget.initialData['phone'] ?? '',
//     );
//     emailController = TextEditingController(
//       text: widget.initialData['user_email'] ?? '',
//     );
//     newPasswordController = TextEditingController();
//     oldPasswordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     newPasswordController.dispose();
//     oldPasswordController.dispose();
//     super.dispose();
//   }

//   /// إعادة تعيين الحقول إلى القيم الأصلية
//   void _resetFields() {
//     setState(() {
//       isEditing = false;
//       nameController.text = widget.initialData['user_name'] ?? '';
//       phoneController.text = widget.initialData['phone'] ?? '';
//       emailController.text = widget.initialData['user_email'] ?? '';
//       newPasswordController.clear();
//       oldPasswordController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 30),

//             // أيقونة الرأس
//             const PersonalHeaderIcon(),

//             const SizedBox(height: 30),

//             // حقول الإدخال الأساسية
//             PersonalTextField(
//               enabled: isEditing,
//               controller: nameController,
//               label: S.of(context).userName,
//               icon: Icons.person_outline,
//             ),

//             const SizedBox(height: 15),

//             PersonalTextField(
//               enabled: isEditing,
//               controller: phoneController,
//               label: S.of(context).phone,
//               icon: Icons.phone_android,
//               keyboardType: TextInputType.phone,
//             ),

//             const SizedBox(height: 15),

//             PersonalTextField(
//               enabled: isEditing,
//               controller: emailController,
//               label: S.of(context).email,
//               icon: Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//             ),

//             // حقول كلمة المرور (تظهر فقط في وضع التعديل)
//             if (isEditing) ...[
//               const SizedBox(height: 15),
//               PersonalPasswordFields(
//                 oldPasswordController: oldPasswordController,
//                 newPasswordController: newPasswordController,
//               ),
//             ],

//             const SizedBox(height: 40),

//             // أزرار الإجراءات
//             PersonalActionButtons(
//               isEditing: isEditing,
//               onEditPressed: () => setState(() => isEditing = true),
//               onSavePressed: _validateAndSave,
//               onCancelPressed: _resetFields,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// التحقق من صحة البيانات وحفظها
//   void _validateAndSave() {
//     if (oldPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(S.of(context).oldPasswordRequired)),
//       );
//       return;
//     }

//     context.read<PersonalCubit>().updatePersonalProfile(
//       name: nameController.text,
//       phone: phoneController.text,
//       email: emailController.text,
//       newPassword: newPasswordController.text,
//       oldPassword: oldPasswordController.text,
//     );
//   }
// }
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
