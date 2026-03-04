// lib/featurees/main_screens/profile/presentation/views/widgets/profile_menu_item.dart

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// عنصر القائمة في صفحة الملف الشخصي

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isLogout;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: AppColors.whiteColor,
        // elevation: 0,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: [
                Icon(icon, color: color ?? AppColors.blackColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: AppStyles.InriaSerif_16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isLogout)
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: AppColors.GrayIconColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
