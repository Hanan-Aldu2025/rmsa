import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomCartStepper extends StatelessWidget {
  final int currentStep; // 1 = Cart, 2 = Payment

  const CustomCartStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    Color activeColor = AppColors.primaryColor; // لون الدائرة النشطة
    Color inactiveColor =
        AppColors.backgroundGraybutton; // لون الدائرة الغير نشطة
    Color lineActiveColor = AppColors.primaryColor;
    Color lineInactiveColor = AppColors.backgroundGraybutton;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizintalPadding,
        vertical: 10,
      ),
      child: Row(
        children: [
          // خطوة 1: Cart
          Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: currentStep >= 1 ? activeColor : inactiveColor,
                child: Text(
                  '1',
                  style: AppStyles.InriaSerif_16.copyWith(
                    color: currentStep >= 1
                        ? AppColors.borderColor
                        : AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).cart,
                style: AppStyles.InriaSerif_14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),

          // الخط بين الخطوتين
          Expanded(
            child: Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: currentStep > 1 ? lineActiveColor : lineInactiveColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // خطوة 2: Payment
          Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: currentStep >= 2 ? activeColor : inactiveColor,
                child: Text(
                  '2',
                  style: AppStyles.titleLora18.copyWith(
                    color: currentStep == 1
                        ? AppColors.primaryColor
                        : AppColors.borderColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).Payment,
                style: AppStyles.InriaSerif_14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
