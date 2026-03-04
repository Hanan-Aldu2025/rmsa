// lib/featurees/main_screens/product_details/presentation/views/widgets/custom_button_back.dart

import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// زر الرجوع المخصص
class CustomButtonBack extends StatelessWidget {
  const CustomButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 20,
      start: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: CircleAvatar(
          backgroundColor: AppColors.whiteColor.withOpacity(0.8),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.blackColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
