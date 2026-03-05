import 'package:flutter/material.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';

class PriceSummaryRow extends StatelessWidget {
  final String title;
  final double value;
  final String? type;

  const PriceSummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.titleLora14.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          if (type != null && type!.isNotEmpty)
            Expanded(
              child: Center(child: Text(type!, style: AppStyles.InriaSerif_14)),
            ),
          Text(value.toStringAsFixed(2), style: AppStyles.InriaSerif_14),
        ],
      ),
    );
  }
}
