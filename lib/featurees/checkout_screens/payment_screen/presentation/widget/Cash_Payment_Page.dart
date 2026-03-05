import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/order_tracking_page.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cash_cubit/cash_payment_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cash_cubit/cash_payment_state.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/views/custom_summary_view.dart';
import 'package:appp/featurees/main_Screens/product_screen/dummy_proudect.dart';
import 'package:appp/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CashPaymentPage extends StatelessWidget {
  const CashPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CashPaymentCubit>();

    return BlocConsumer<CashPaymentCubit, CashPaymentState>(
      listener: (context, state) {
        if (state is CashPaymentSuccess) {
          // 🟢 التنقل يكون هنا فقط
          Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => OrderTrackingCubit(),
      child:  OrderTrackingPage(),
    ),
  ),
);

          // 🟢 تنظيف السلة
          context.read<CartCubit>().clearCart();
        }

        if (state is CashPaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
            context,
            title: S.of(context).Payment,
            ontap: () => Navigator.pop(context),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizintalPadding,
              vertical: kverticalPadding,
            ),
            child: Column(
              children: [
                Expanded(child: CustomSummaryView()),
                const SizedBox(height: 10),

                CustomButton(
                  onpressed: state is CashPaymentLoading
                      ? null
                      : () => cubit.confirmCashOrder(),
                  text: S.of(context).continueBtn,
                ),

                const SizedBox(height: 24),

                if (state is CashPaymentLoading)
                  const CircularProgressIndicator(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
