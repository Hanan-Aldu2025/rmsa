import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/core/widget/custom_divider.dart';
import 'package:appp/core/widget/custom_text_filed.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';

import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/card_cubit/card_payment_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/Card_payment_summary_page.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardPaymentPage extends StatefulWidget {
  const CardPaymentPage({super.key});
  static const routeName = "CardPaymentPage";

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _holderNameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _holderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      appBar: buildAppBar(context, title: S.of(context).payWithCard),
      body: BlocListener<CardPaymentCubit, CardPaymentState>(
        listener: (context, state) async {
          // ✅ عند النجاح → رفع الأوردر والانتقال للـ Summary
          if (state is CardPaymentSuccess) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<CardPaymentCubit>(), // هنا نعيد استخدام الـ Cubit الحالي
        child: CardPaymentSummaryPage(orderId: state.orderId),
      ),
    ),
  );
}
          // ❌ عند الفشل → رسالة فقط
          if (state is CardPaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardForm(),
              const SizedBox(height: 24),
              _buildOrderSummary(cartCubit),
              const SizedBox(height: 24),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- Card Form --------------------
  Widget _buildCardForm() {
    return CustomBorderContainer(
      mychild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).cardDetails,
              style: AppStyles.titleLora18.copyWith(
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextFormFiled(
              hinttext: S.of(context).cardNumber,
              controller: _cardNumberController,
              textInputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return S.of(context).required;
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormFiled(
                    hinttext: S.of(context).expiryDate,
                    controller: _expiryController,
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return S.of(context).required;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormFiled(
                    hinttext: S.of(context).cvv,
                    controller: _cvvController,
                    textInputType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return S.of(context).required;
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextFormFiled(
              hinttext: S.of(context).cardHolderName,
              controller: _holderNameController,
              textInputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) return S.of(context).required;
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Order Summary --------------------
  Widget _buildOrderSummary(CartCubit cartCubit) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        double subtotal = cartCubit.productsTotal;
        double tax = cartCubit.taxValue;
        double delivery = cartCubit.deliveryCost;
        double total = cartCubit.totalWithTaxAndDelivery;

        return CustomBorderContainer(
          mychild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).orderSummary,
                style: AppStyles.textLora16.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _summaryRow(S.of(context).subtotalLabel, subtotal),
              _summaryRow(S.of(context).tax, tax),
              _summaryRow(S.of(context).delivery, delivery),
              my_divider(),
              _summaryRow(S.of(context).total, total, isTotal: true),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryRow(String title, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyles.InriaSerif_14),
          Text(
            value.toStringAsFixed(2),
            style: AppStyles.InriaSerif_16.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- Pay Button --------------------
  Widget _buildPayButton() {
    return Center(
      child: BlocBuilder<CardPaymentCubit, CardPaymentState>(
        builder: (context, state) {
          final isLoading = state is CardPaymentLoading;
          return CustomButton(
            text: S.of(context).payNow,
            isLoading: isLoading,
            onpressed: isLoading ? null : _onPayPressed,
            mycolor: AppColors.primaryColor,
          );
        },
      ),
    );
  }

  // -------------------- Action --------------------
  void _onPayPressed() {
    if (!_formKey.currentState!.validate()) return;

    final cardCubit = context.read<CardPaymentCubit>();
    cardCubit.pay(
      cardNumber: _cardNumberController.text,
      expiry: _expiryController.text,
      cvv: _cvvController.text,
      holderName: _holderNameController.text,
    );
  }
}
