import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Text HaveAccount(BuildContext context) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: S.of(context).already_have_account,
          style: AppStyles.InriaSerif_14,
        ),
        TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pop(context, LoginView.routeName);
            },
          text: S.of(context).login,
          style: AppStyles.textLora16,
        ),
      ],
    ),
  );
}
