import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/utils/app_style.dart';
import 'package:appp/utils/app_colors.dart';

class SubTotalPrice extends StatelessWidget {
  const SubTotalPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cubit = context.read<CartCubit>();
          return Row(
            children: [
              Text("Subtotal : ", style: AppStyles.titleLora18),
              const Spacer(), // يسمح بالمسافة بين النص والسعر
              Text(
                '\$${cubit.productsTotal.toStringAsFixed(2)}',
                style: AppStyles.textLora16,
              ),
            ],
          );
        },
      ),
    );
  }
}
