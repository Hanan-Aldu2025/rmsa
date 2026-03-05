import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_test_ui.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/views/payment_method_View.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_total_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';

import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';

import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_body_item_listview.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_cart_stepper.dart';

import 'package:appp/core/constans/constans_kword.dart';

class CartViewBody extends StatefulWidget {
  final List<CartItemEntity> items;

  const CartViewBody({super.key, required this.items});

  @override
  State<CartViewBody> createState() => _CartViewBodyState();
}

class _CartViewBodyState extends State<CartViewBody> {
  @override
  void initState() {
    super.initState();
      context.read<CartCubit>().resetCartAfterCheckout();   // ← هذا المهم
      context.read<CartCubit>().fetchDeliveryOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
          child: Column(
            children: [
              // ================= Header ثابت =================
              CustomCartStepper(currentStep: 1),
              const SizedBox(height: 8),

              // ================= Scroll Responsive =================
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ===== المنتجات =====
                            ...List.generate(
                              widget.items.length,
                              (index) => CustomBodyItemListView(
                                items: [widget.items[index]],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ===== السعر والتفاصيل =====
                            TotalPricePage(),
//                             //----------------------------
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddDriverPage(),
      ),
    );
  },
  child: const Text("Add Driver"),
),
//---------------------------------------------------
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ================= Button ثابت =================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kHorizintalPadding,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PaymentMethodView()),
                      );
                    },
                    text: 'اختر الدفع',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
