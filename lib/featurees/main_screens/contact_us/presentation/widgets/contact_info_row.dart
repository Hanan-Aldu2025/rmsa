// lib/featurees/main_screens/contact_us/presentation/views/widgets/contact_info_row.dart

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// صف معلومات التواصل (أيقونة + نص)
class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactInfoRow({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: AppStyles.InriaSerif_14.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
