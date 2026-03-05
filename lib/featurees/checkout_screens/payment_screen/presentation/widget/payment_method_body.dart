import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/models/payment_method_option_model.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cash_cubit/cash_payment_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cubit_payment_method/payment_method_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cubit_payment_method/payment_method_state.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/Card_payment_Page.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/Cash_Payment_Page.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/Mobile_Wallet_Page.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';

class PaymentMethodBody extends StatelessWidget {
  const PaymentMethodBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentMethodCubit, PaymentMethodState>(
      listener: (context, state) {
        // إذا حصل خطأ، نعرض Dialog
        if (state.errorMessage != null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(S.of(context).error),
                ],
              ),
              content: Text(state.errorMessage!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(S.of(context).ok),
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
        builder: (context, state) {
          // ----------------------------
          // إذا المستخدم اختار طريقة الدفع وأكدها
          // ----------------------------
          if (state.isConfirmed && state.selectedMethodId != null) {
            switch (state.selectedMethodId) {
              case "COD":
                // CashPaymentPage ستستخدم Cubit الموجود في CheckoutRoot
                return BlocProvider.value(
                  value: context
                      .read<CashPaymentCubit>(), // تمرير نفس الـ Cubit
                  child: const CashPaymentPage(),
                );
              case "CARD":
                return const CardPaymentPage();
              case "MOBILE":
                return const MobilePaymentPage();
            }
          }
          // ----------------------------
          // شاشة اختيار طريقة الدفع
          // ----------------------------
          return Scaffold(
            appBar: buildAppBar(context, title: S.of(context).choosePaymentMethod),
            body: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kHorizintalPadding,
                      vertical: kverticalPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),

                        // ✅ قائمة طرق الدفع
                        ...paymentMethods.map((method) {
                          final isSelected =
                              state.selectedMethodId == method.id;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context
                                  .read<PaymentMethodCubit>()
                                  .selectMethod(method.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSceenColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.borderColor,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      method.icon,
                                      size: 26,
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : Colors.black,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        method.title,
                                        style: AppStyles.InriaSerif_16,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        LucideIcons.checkCircle,
                                        color: AppColors.primaryColor,
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 32),

                        // ✅ زر متابعة
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onpressed: state.selectedMethodId == null
                                ? null
                                : () {
                                    // نقوم بتأكيد اختيار طريقة الدفع
                                    // بعد التأكيد، BlocBuilder سيعيد بناء الصفحة
                                    // وسيتم عرض Cash / Card / Mobile Page
                                    context
                                        .read<PaymentMethodCubit>()
                                        .confirm();
                                  },
                            text: S.of(context).continueBtn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
