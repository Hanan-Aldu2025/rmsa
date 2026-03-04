// lib/featurees/main_screens/complaint/presentation/views/widgets/complaint_submit_button.dart

import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';

/// زر إرسال الشكوى
class ComplaintSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ComplaintSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return CustomButton(onpressed: onPressed, text: lang.send);
  }
}
