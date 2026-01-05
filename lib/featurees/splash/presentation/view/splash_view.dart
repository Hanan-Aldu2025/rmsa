// lib/features/splash/view/splash_view.dart
import 'package:appp/core/helper_fauniction/animated.dart';
import 'package:appp/featurees/splash/view_model/splash_view_model.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String routeName = "/SplashView";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SplashViewModel>().initSplash(context));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SplashViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundSceenColor,
      body: Center(
        child: AnimatedLogo(
          title: vm.appName,
          subtitle: vm.slogan,
          opacity: vm.opacity,
        ),
      ),
    );
  }
}
