// lib/featurees/main_screens/personal/presentation/views/widgets/personal_text_field.dart

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

// /// حقل نصي مخصص لصفحة البيانات الشخصية
// class PersonalTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final IconData icon;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final bool enabled;

//   const PersonalTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.icon,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // عنوان الحقل
//         Text(
//           label,
//           style: AppStyles.InriaSerif_14.copyWith(
//             fontWeight: FontWeight.bold,
//             color: enabled ? AppColors.primaryColor : AppColors.GrayIconColor,
//           ),
//         ),

//         const SizedBox(height: 8),

//         // حقل الإدخال
//         TextFormField(
//           key: key,
//           controller: controller,
//           obscureText: isPassword,
//           keyboardType: keyboardType,
//           enabled: true, // دائماً مفعل لاستقبال اللمس
//           readOnly: !enabled, // منع الكتابة إذا لم يكن في وضع التعديل
//           enableInteractiveSelection: true,
//           cursorColor: AppColors.primaryColor,
//           cursorWidth: 2.0,
//           cursorRadius: const Radius.circular(2),
//           style: AppStyles.InriaSerif_14.copyWith(
//             color: enabled ? Colors.black : AppColors.GrayIconColor,
//           ),
//           onTapOutside: (event) => FocusScope.of(context).unfocus(),

//           decoration: InputDecoration(
//             prefixIcon: Icon(
//               icon,
//               color: enabled
//                   ? AppColors.primaryColor
//                   : AppColors.GrayIconColor.withOpacity(0.5),
//             ),
//             filled: true,
//             fillColor: enabled
//                 ? AppColors.backgroundGraybutton.withOpacity(0.5)
//                 : Colors.grey.shade100,

//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 20,
//             ),

//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: enabled ? AppColors.borderColor : Colors.grey.shade300,
//               ),
//             ),

//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: enabled ? AppColors.borderColor : Colors.grey.shade300,
//                 width: 1.5,
//               ),
//             ),

//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: enabled ? AppColors.primaryColor : Colors.grey.shade300,
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
/// حقل نصي مخصص لصفحة البيانات الشخصية
class PersonalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool enabled;

  const PersonalTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل
        Text(
          label,
          style: AppStyles.InriaSerif_14.copyWith(
            fontWeight: FontWeight.bold,
            color: enabled ? AppColors.primaryColor : AppColors.GrayIconColor,
          ),
        ),

        const SizedBox(height: 8),

        // حقل الإدخال
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          enabled: true, // دائماً مفعل لاستقبال اللمس
          readOnly: !enabled, // منع الكتابة إذا لم يكن في وضع التعديل
          enableInteractiveSelection: true, // تمكين التحديد وسحب المؤشر
          cursorColor: AppColors.primaryColor,
          cursorWidth: 2.0,
          cursorRadius: const Radius.circular(2),
          style: AppStyles.InriaSerif_14.copyWith(
            color: enabled ? Colors.black : AppColors.GrayIconColor,
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),

          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled
                  ? AppColors.primaryColor
                  : AppColors.GrayIconColor.withOpacity(0.5),
            ),
            filled: true,
            fillColor: enabled
                ? AppColors.backgroundGraybutton.withOpacity(0.5)
                : Colors.grey.shade100,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: enabled ? AppColors.borderColor : Colors.grey.shade300,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: enabled ? AppColors.borderColor : Colors.grey.shade300,
                width: 1.5,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: enabled ? AppColors.primaryColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
