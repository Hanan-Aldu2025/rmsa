import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppStyles {
  // 🔹 Lora 24 Black
  static final TextStyle titleLora24 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 24,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w700, // Bold
  );
  // 🔹 Lora 18 SemiBold
  static final TextStyle titleLora14 = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 14,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w600, // SemiBold
  );
  // 🔹 Lora 18 SemiBold
  static final TextStyle titleLora18 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 18,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w600, // SemiBold
  );

  // 🔹 Lora 16 Medium
  static final TextStyle textLora16 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 16,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w500, // Medium
  );

  // 🔹 Lora 12 Gray (#C0C4CC)
  static final TextStyle textLora12Gray = TextStyle(
    color: Color(0xFFC0C4CC),
    fontSize: 12,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w400, // Regular
  );

  // 🔹 Inter 16 Medium
  static final TextStyle InriaSerif_16 = TextStyle(
    color: Color(0xFF000000),
    fontSize: 16,
    fontFamily: 'InriaSerif',
    fontWeight: FontWeight.w600, // Medium
  );

  // 🔹 Inter 14 Gray (#565D6D)
  static final TextStyle InriaSerif_14 = TextStyle(
    color: Color(0xFF565D6D),
    fontSize: 14,
    fontFamily: 'InriaSerif',
    fontWeight: FontWeight.w500, // Regular
  );
}
