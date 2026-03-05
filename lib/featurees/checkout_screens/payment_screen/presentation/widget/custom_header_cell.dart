import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;
  final bool isHighlight;

  const HeaderCell({
    super.key,
    required this.text,
    this.flex = 1,
    this.align = TextAlign.center,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.titleLora14.copyWith(
          color: isHighlight
              ? AppColors.primaryColor
              : AppStyles.titleLora14.color,
          fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}