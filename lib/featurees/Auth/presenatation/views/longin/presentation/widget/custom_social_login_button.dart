import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSocialLoginButton extends StatelessWidget {
  const CustomSocialLoginButton({
    super.key,
    required this.title,
    required this.image,
    required this.onPressed,
  });
  final String title;
  final Image image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.onPressedColor, width: 1),
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
        ),
        onPressed: onPressed,

        child: ListTile(
          visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity),
          title: Text(title, style: AppStyles.titleLora18),
          leading: SizedBox(height: 45, width: 45, child: image),
        ),
      ),
    );
  }
}
