import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

// ===== كلاس الزر المستقل =====
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onpressed;
  final Color? mycolor;

  const CustomButton({
    super.key,
    required this.text,
    this.onpressed,
    this.mycolor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onpressed != null;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 60,
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isEnabled
              ? AppColors.primaryColor
              : AppColors.onPressedColor, // لون الخلفية للمعطّل
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppStyles.titleLora18.copyWith(
            color: isEnabled ? Colors.white : Colors.black, // 🔹 نص أسود إذا معطّل
          ),
        ),
      ),
    );
  }
}