// lib/featurees/main_screens/complaint/presentation/views/widgets/complaint_text_field.dart

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// حقل إدخال الشكوى
class ComplaintTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;

  const ComplaintTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل
        Text(title, style: AppStyles.titleLora18),

        const SizedBox(height: 12),

        // حقل الإدخال
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.backgroundGraybutton,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: TextField(
            controller: controller,
            maxLines: 6,
            style: AppStyles.InriaSerif_14,
            enableInteractiveSelection: true,
            cursorColor: AppColors.primaryColor,
            cursorWidth: 2.0,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppStyles.InriaSerif_14.copyWith(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
