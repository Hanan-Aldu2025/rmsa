import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountWidget extends StatefulWidget {
  const DiscountWidget({Key? key}) : super(key: key);

  @override
  State<DiscountWidget> createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> {
  final TextEditingController _couponController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // إضافة FocusNode
  String? _message;
  bool _isSuccess = false;

  @override
  void dispose() {
    _couponController.dispose();
    _focusNode.dispose(); // تخلص من FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // لضمان التقاط أي ضغط خارج
      onTap: () {
        FocusScope.of(context).unfocus(); // يفقد التركيز من أي TextField
      },
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cartCubit = context.read<CartCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== إدخال الكود + زر التطبيق =====
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      focusNode: _focusNode, // ربط FocusNode
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "أدخل كود الخصم",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onChanged: (value) {
                        // عند الكتابة إعادة تعيين الرسالة
                        setState(() {
                          _message = null;
                          _isSuccess = false;
                        });
                      },
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
                    onPressed: () async {
                      final code = _couponController.text.trim();
                      if (code.isEmpty) return;

                      await cartCubit.applyDiscountCode(code);

                      setState(() {
                        if (cartCubit.discountErrorMessage != null) {
                          _isSuccess = false;
                          _message = cartCubit.discountErrorMessage;
                        } else {
                          _isSuccess = true;
                          _message =
                              "تم تطبيق الخصم، المجموع بعد الخصم: "
                              "${cartCubit.totalAfterDiscount.toStringAsFixed(2)} ر.س";
                        }
                      });

                      // بعد التطبيق إخراج التركيز
                      _focusNode.unfocus();
                      _couponController.clear(); // يمسح النص
                    },
                    child: Text(
                      "تطبيق",
                      style: AppStyles.textLora16.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

// ===== رسالة النتيجة =====
              if (_message != null)
                Text(
                  _isSuccess ? "✅ $_message" : "❌ $_message",
                  style: TextStyle(
                    fontSize: 15,
                    color: _isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}