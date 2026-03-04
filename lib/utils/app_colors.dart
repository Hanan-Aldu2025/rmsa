import 'package:flutter/material.dart';

class AppColors {
  // اللون الأساسي للمشروع
  static const Color primaryColor = Color(0xFF3D0E00);
  // لون الضغط على الأزرار
  static const Color onPressedColor = Color(0xFF731B00);

  static const Color borderColor = Color(0xFFDEE1E6);
  static const Color whiteColor = Color.fromARGB(255, 250, 249, 248);

  static const Color blackColor = Color(0xFF000000);
  // ignore: constant_identifier_names
  static const Color GrayIconColor = Color(0xFF565D6D);
  static const Color backgroundGraybutton = Color(0xFFF3F4F6);
  static const Color backgroundSceenColor = Color(0xFFFFF3F0);
  //-----------------------------------------------------------------------

  // ألوان الوضع الفاتح (Light Mode)
  static const Color backgroundLight = Color(0xFFFFF3F0);
  static const Color cardLight = Color.fromARGB(255, 250, 249, 248);
  static const Color textLight = Color(0xFF000000);

  // ألوان الوضع الداكن (Dark Mode)
  static const Color backgroundDark = Color(0xFF1A1A1A); // أسود رمادي
  static const Color cardDark = Color(0xFF2D2D2D); // رمادي أغمق
  static const Color textDark = Color(0xFFFFFFFF); // أبيض
}
