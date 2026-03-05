import 'package:flutter/material.dart';
import 'package:appp/utils/app_style.dart';

class SummaryRowCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;

  const SummaryRowCell({
    super.key,
    required this.text,
    this.flex = 1,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        style: AppStyles.InriaSerif_14,
      ),
    );
  }
}