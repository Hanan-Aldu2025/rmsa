import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/views/custom_summary_view.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/card_cubit/card_payment_cubit.dart';
import 'package:appp/generated/l10n.dart';

class CardPaymentSummaryPage extends StatelessWidget {
  final String orderId;

  const CardPaymentSummaryPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // ⚡ هنا لن نستخدم context.read<CardPaymentCubit>() مباشرة
    // بل سيتم تمريره عن طريق BlocProvider عند التنقل
    return Scaffold(
      appBar: buildAppBar(context, title: S.of(context).orderSummary),
      body: Column(
        children: [
          //================================//
          Expanded(
            
            child: CustomSummaryView(), // عرض ملخص الأوردر
          ),
          //================================//
          const SizedBox(height: 16),
          // زر تتبع الأوردر
          //================================//
          BlocBuilder<CardPaymentCubit, CardPaymentState>(
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
    final cubit = context.read<CardPaymentCubit>();
    cubit.goToOrderTracking(context: context, orderId: orderId);
  },
);
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
