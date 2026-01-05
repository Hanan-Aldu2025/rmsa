import 'package:appp/core/app.dart';
import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/services/shared_preverences_singleton.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/main_Screens/product_screen/dummy_proudect.dart';
import 'package:appp/featurees/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class LanguageSelectionView extends StatelessWidget {
  static const String routeName = "/languageSelection";

  const LanguageSelectionView({super.key});

  void _handleLanguageSelection(BuildContext context, Locale locale) {
    AppBootstrap.setLocale(context, locale);

    bool isOnBoardingVieweSeen = AppPrefs.getBool(
      kIsOnBoardingVieweSeen,
    ); // ✅ الفحص هنا

    if (isOnBoardingVieweSeen) {
      //mainview
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    } else {
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingHorizontal = size.width * 0.1; // 10% من عرض الشاشة
    final spacingVertical = size.height * 0.02; // 2% من ارتفاع الشاشة

    return Scaffold(
      backgroundColor: AppColors.backgroundSceenColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("اختر اللغة", style: AppStyles.titleLora18),
            Text("Choose Language", style: AppStyles.titleLora18),
            SizedBox(height: spacingVertical),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onPressedColor,
                ),
                onPressed: () =>
                    _handleLanguageSelection(context, const Locale("en")),
                child: Text(
                  "English",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: spacingVertical),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onPressedColor,
                ),
                onPressed: () =>
                    _handleLanguageSelection(context, const Locale("ar")),
                child: Text(
                  "العربية",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
