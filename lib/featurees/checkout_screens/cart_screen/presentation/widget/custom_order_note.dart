import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
class customOrderNote extends StatefulWidget {
  const customOrderNote({Key? key}) : super(key: key);

  @override
  State<customOrderNote> createState() => _customOrderNoteState();
}

class _customOrderNoteState extends State<customOrderNote> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _message;
  bool _saved = false;

  @override
  void initState() {
    super.initState();

    // Listener لمراقبة النص أثناء الكتابة
    _noteController.addListener(() {
      setState(() {
        _message = _noteController.text.isEmpty
            ? "لا توجد ملاحظة حالياً"
            : _noteController.text;
        _saved = false; // لأنه لم يتم حفظه بعد
      });

      // طباعة الملاحظة في الكونسول أثناء الكتابة
     // print("📝 الملاحظة أثناء الكتابة: ${_noteController.text}");
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "ملاحظة الطلب (اختياري)",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  final note = _noteController.text.trim();

                  cartCubit.updateOrderNote(note);

                  setState(() {
                    _saved = true;
                    _message = note.isEmpty
                        ? "تم حفظ الطلب بدون ملاحظة"
                        : "تم حفظ الملاحظة";
                  });

                  _focusNode.unfocus();

                  // طباعة الملاحظة بعد الحفظ
                  print("✅ الملاحظة بعد الحفظ: $note");
                },
                child: Text(
                  "حفظ",
                  style: AppStyles.textLora16.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (_message != null)
            Text(
              _saved ? "✅ $_message" : "📝 $_message",
              style: TextStyle(
                fontSize: 15,
                color: _saved ? Colors.green : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}