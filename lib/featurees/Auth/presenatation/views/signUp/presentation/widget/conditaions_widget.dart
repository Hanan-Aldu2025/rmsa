import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'custom_checkbox.dart';

class ConditionsWidget extends StatelessWidget {
  final bool value; // 👈 يستقبل القيمة من SignupViewBody
  final void Function(bool)? onChanged;

  const ConditionsWidget({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Row(
        children: [
          CustomCheckbox(
            isCheckbox: value,
            onChanged: (val) => onChanged?.call(val),
          ),
          const SizedBox(width: 8),
          Expanded(
            // تم التعديل هنا من Row إلى Wrap
            child: Wrap(
              children: [
                Text(
                  S.of(context).agree_prefix,
                  style: AppStyles.InriaSerif_14,
                ),
                Text(
                  S.of(context).terms_and_conditions,
                  style: AppStyles.InriaSerif_16.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
