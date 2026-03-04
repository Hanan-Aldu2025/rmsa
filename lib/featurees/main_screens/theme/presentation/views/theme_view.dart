import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/theme/presentation/widgets/theme_view_body.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';

/// صفحة إعدادات المظهر - نقطة الدخول
class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: S.of(context).themeSetting),
      body: const ThemeViewBody(),
    );
  }
}
