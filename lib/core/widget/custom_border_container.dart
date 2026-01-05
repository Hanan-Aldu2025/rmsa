import 'package:flutter/material.dart';

class CustomBorderContainer extends StatelessWidget {
  const CustomBorderContainer({
    super.key,
    required this.mychild,
    this.myheight,
    this.mywidth,
    this.myColor,
    this.showBorder = true, // ✅ افتراضيًا يظهر البوردر
  });

  final Widget mychild;
  final double? myheight;
  final double? mywidth;
  final Color? myColor;
  final bool showBorder; // ✅ متغير للتحكم بظهور البوردر

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = mywidth ?? screenWidth * 0.95;

    return Container(
      width: containerWidth,
      height: myheight,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: myColor ?? Colors.white,
        border: showBorder
            ? Border.all(color: Colors.grey.shade300) // ✅ بوردر رمادي خفيف
            : null, // ❌ بدون بوردر
        borderRadius: BorderRadius.circular(12),
      ),
      child: mychild,
    );
  }
}