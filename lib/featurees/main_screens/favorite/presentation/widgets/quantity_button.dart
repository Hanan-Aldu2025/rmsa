// lib/featurees/main_screens/favorite/presentation/views/widgets/quantity_button.dart

import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// زر التحكم في الكمية (دائري)
class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white24,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: size * 0.6, color: Colors.white),
      ),
    );
  }
}
