import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(context, {required String title}) {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.blackColor),
    ),
    centerTitle: true,
    title: Text(title, style: AppStyles.titleLora18),
  );
}
