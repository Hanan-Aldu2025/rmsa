import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/core/widget/custom_divider.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_choose_delivery_option.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_discount.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_order_note.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_subtotal_price.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';

class TotalPricePage extends StatelessWidget {
  const TotalPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: SingleChildScrollView(
        child: CustomBorderContainer(
          // ✅ لا height
          mychild: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final cubit = context.watch<CartCubit>();
              final total = cubit.totalWithTaxAndDelivery;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customOrderNote(),
                    my_divider(),

                    SubTotalPrice(),
                    my_divider(),

                    DiscountWidget(),
                    my_divider(),

                    CustomChooseDeliveryOption(),
                    my_divider(),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Total Price :", style: AppStyles.titleLora18),
                          const Spacer(),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: AppStyles.textLora16,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "*شامل ضريبة القيمة المضافة",
                      style: AppStyles.InriaSerif_14,
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
