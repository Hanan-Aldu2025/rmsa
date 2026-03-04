// lib/featurees/main_screens/theme/presentation/views/widgets/theme_option_item.dart

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// عنصر خيار المظهر (نهاري/ليلي)
class ThemeOptionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeOptionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // تحسين منطقة اللمس
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : AppColors.backgroundGraybutton,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // الأيقونة
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.GrayIconColor,
              size: 24,
            ),

            const SizedBox(width: 15),

            // النص
            Expanded(
              child: Text(
                title,
                style: AppStyles.InriaSerif_14.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),

            // علامة الاختيار
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
