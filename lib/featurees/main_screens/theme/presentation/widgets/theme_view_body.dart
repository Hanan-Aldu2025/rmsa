// lib/featurees/main_screens/theme/presentation/views/theme_view_body.dart

import 'package:appp/core/app.dart';
import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/theme/presentation/widgets/theme_option_item.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// جسم صفحة إعدادات المظهر
class ThemeViewBody extends StatelessWidget {
  const ThemeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // عنوان الصفحة
          Text(lang.chooseAppearance, style: AppStyles.titleLora18),

          const SizedBox(height: 20),

          // خيار الوضع النهاري
          ThemeOptionItem(
            title: lang.lightMode,
            icon: Icons.light_mode_outlined,
            isSelected: !isDark,
            onTap: () => AppBootstrap.setTheme(context, false),
          ),

          const SizedBox(height: 15),

          // خيار الوضع الليلي
          ThemeOptionItem(
            title: lang.darkMode,
            icon: Icons.dark_mode_outlined,
            isSelected: isDark,
            onTap: () => AppBootstrap.setTheme(context, true),
          ),
        ],
      ),
    );
  }
}
