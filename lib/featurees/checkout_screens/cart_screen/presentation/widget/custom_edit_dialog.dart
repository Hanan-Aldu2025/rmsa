import 'package:appp/core/widget/custom_text_button.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class EditNoteDialog extends StatefulWidget {
  final String initialNote;

  const EditNoteDialog({super.key, required this.initialNote});

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
    //  title: const Text("تعديل الملاحظة"),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        style: AppStyles.InriaSerif_14,
        decoration: InputDecoration(
          hintText: "اكتب ملاحظتك هنا...",
          hintStyle: AppStyles.InriaSerif_14.copyWith(
            color: Colors.grey,
          ),

          /// ⭐ هذا المهم
          filled: true,
          fillColor: Colors.grey.shade100, // لون ثابت

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade300, // نفس اللون → ما ينور
            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      actions: [
        CustomTextButton(
          onpressed: () {
            Navigator.pop(context);
          },
          text: "إلغاء",
        ),
        CustomTextButton(
          onpressed: () {
            Navigator.pop(context, _controller.text.trim());
          },
          text: "حفظ",
        ),
      ],
    );
  }
}