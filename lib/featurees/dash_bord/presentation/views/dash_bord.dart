import 'package:appp/featurees/adaptive_layout/presentation/views/widget/adaptive_layout.dart';
import 'package:appp/featurees/mobile_app/presentation/views/mobile.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DashBorad extends StatelessWidget {
  const DashBorad({super.key});
  static const String routeName = "DashBorad";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSceenColor,
      body: myAdaptivelayout(
        mobillayout: (BuildContext context) => const MobileApp(),
        tablayout: (BuildContext context) => const SizedBox(),
        desktoplayout: (BuildContext context) => const SizedBox(),
      ),
    );
  }
}
