import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/mobile_wallet_cubit/moile_wallet_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/views/custom_summary_view.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/mobile_wallet_summary_page.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';

class MobilePaymentPage extends StatelessWidget {
  const MobilePaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return BlocListener<MobilePaymentCubit, MobilePaymentState>(
      listener: (context, state) {
        if (state is MobilePaymentSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MobilePaymentSummaryPage(orderId: state.orderId),
            ),
          );
        }

        if (state is MobilePaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: buildAppBar(context, title: S.of(context).payWithMobile),
        body: Column(
          children: [
            Expanded(child: CustomSummaryView()), // ملخص الطلب
            Padding(
              padding: const EdgeInsets.all(16),
              //=============================================================//
              child: BlocBuilder<MobilePaymentCubit , MobilePaymentState>(
        builder: (context, state) {
          final isLoading = state is MobilePaymentLoading;
          return CustomButton(
            text: S.of(context).payNow,
            isLoading: isLoading,
           // onpressed: isLoading ? null : _onPayPressed,
            mycolor: AppColors.primaryColor,
          );
        },
      ),
      
            ),

      //=================================================================//

           
          ],
        ),
      ),
    );
  }
}
