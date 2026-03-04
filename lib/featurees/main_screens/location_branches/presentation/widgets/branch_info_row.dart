// lib/featurees/main_screens/location/presentation/views/widgets/branch_info_row.dart

import 'package:appp/utils/app_colors.dart';
import 'package:flutter/widgets.dart';

/// صف معلومات الفرع (أيقونة + نص)
class BranchInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const BranchInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
