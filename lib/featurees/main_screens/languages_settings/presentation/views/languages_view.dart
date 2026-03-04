// lib/featurees/main_screens/language/presentation/views/language_view.dart
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/languages_settings/presentation/widgets/language_view_body.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';

/// صفحة إعدادات اللغة - نقطة الدخول
class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: S.of(context).language),
      body: const LanguageViewBody(),
    );
  }
}
