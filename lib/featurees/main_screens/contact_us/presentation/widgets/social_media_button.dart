// lib/featurees/main_screens/contact_us/presentation/views/widgets/social_media_button.dart

import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// زر وسائل التواصل الاجتماعي (دائري)
class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialMediaButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor.withOpacity(0.1),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: AppColors.primaryColor, size: 26),
        ),
      ),
    );
  }
}
