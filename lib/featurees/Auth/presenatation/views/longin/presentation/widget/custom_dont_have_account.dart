import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/views/signup_view.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Text dontHaveAccount(BuildContext context) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: S.of(context).dontHaveAccount,
          style: AppStyles.InriaSerif_14,
        ),
        TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, SignupView.routeName);
            },
          text: S.of(context).signUp,
          style: AppStyles.InriaSerif_16,
        ),
      ],
    ),
  );
}
