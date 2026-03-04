// lib/featurees/main_screens/language/presentation/views/language_view_body.dart

import 'package:appp/core/app.dart';
import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/languages_settings/presentation/widgets/language_option_item.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// جسم صفحة إعدادات اللغة
class LanguageViewBody extends StatelessWidget {
  const LanguageViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final currentLang = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // عنوان الصفحة
          Text(lang.chooseLanguage, style: AppStyles.titleLora18),

          const SizedBox(height: 20),

          // خيار اللغة العربية
          LanguageOptionItem(
            title: "العربية",
            subtitle: "Arabic",
            isSelected: currentLang == 'ar',
            onTap: () => AppBootstrap.setLocale(context, const Locale('ar')),
          ),

          const SizedBox(height: 15),

          // خيار اللغة الإنجليزية
          LanguageOptionItem(
            title: "English",
            subtitle: "الإنجليزية",
            isSelected: currentLang == 'en',
            onTap: () => AppBootstrap.setLocale(context, const Locale('en')),
          ),
        ],
      ),
    );
  }
}
