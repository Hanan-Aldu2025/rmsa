import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/card_cubit/card_payment_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/mobile_wallet_cubit/moile_wallet_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/views/custom_summary_view.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobilePaymentSummaryPage extends StatelessWidget {
  final String orderId;
  const MobilePaymentSummaryPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: S.of(context).orderSummary),
      body: Column(
        children: [
          Expanded(
            child: CustomSummaryView(),
          ), // تمرير orderId لاحقاً لعرض التفاصيل
          Padding(
            padding: const EdgeInsets.all(16),

            child: BlocBuilder<CardPaymentCubit, CardPaymentState>(
              builder: (context, state) {
                return CustomButton(
                  text: S.of(context).orderTracking,
                  onpressed: () {
                    final cartCubit = context.read<CartCubit>();

                    if (cartCubit.items.isEmpty) {
                      // السلة فارغة → رسالة
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).noOrdersCurrently),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // توقف هنا
                    }

                    // السلة فيها أوردر → تابع للتتبع
                    final cubit = context.read<MobilePaymentCubit>();
                    cubit.payWithMobile();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
