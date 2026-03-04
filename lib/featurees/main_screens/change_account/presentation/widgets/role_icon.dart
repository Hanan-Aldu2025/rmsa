// lib/featurees/main_screens/change_account/presentation/views/widgets/role_icon.dart
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// أيقونة الدور مع خلفية دائرية
class RoleIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const RoleIcon({super.key, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor
            : Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : AppColors.GrayIconColor,
      ),
    );
  }
}
