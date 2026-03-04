// lib/featurees/main_screens/personal/presentation/views/widgets/personal_header_icon.dart

import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// أيقونة رأس صفحة البيانات الشخصية
class PersonalHeaderIcon extends StatelessWidget {
  const PersonalHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 45,
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      child: const Icon(
        Icons.manage_accounts,
        size: 45,
        color: AppColors.primaryColor,
      ),
    );
  }
}
