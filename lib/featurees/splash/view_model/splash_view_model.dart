import 'package:appp/featurees/language/presentation/views/language_selection_view.dart';
import 'package:flutter/material.dart';

class SplashViewModel with ChangeNotifier {
  double _opacity = 0.0;
  double get opacity => _opacity;

  String appName = "RMSA Café";
  String slogan = "Taste the Moments ☕";

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _opacity = 1.0;
      notifyListeners();
    });
  }

  Future<void> initSplash(BuildContext context) async {
    startAnimation();
    await Future.delayed(const Duration(seconds: 4));
    // ✅ دايمًا يروح لصفحة اختيار اللغة
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LanguageSelectionView()),
    );
  }
}
