// lib/featurees/main_screens/personal/presentation/views/widgets/personal_action_buttons.dart

import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';

/// أزرار الإجراءات (تعديل/حفظ/إلغاء)
class PersonalActionButtons extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;

  const PersonalActionButtons({
    super.key,
    required this.isEditing,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    if (!isEditing) {
      // زر التعديل
      return CustomButton(text: lang.edit, onpressed: onEditPressed);
    }

    // أزرار الحفظ والإلغاء
    return Column(
      children: [
        // زر حفظ التغييرات
        CustomButton(text: lang.saveChanges, onpressed: onSavePressed),

        const SizedBox(height: 12),

        // زر إلغاء التعديل
        CustomButton(
          text: lang.cancel,
          mycolor: Colors.grey[400],
          onpressed: onCancelPressed,
        ),
      ],
    );
  }
}
