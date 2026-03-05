import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/cart_view_body.dart';

class CartConsumer extends StatelessWidget {
  const CartConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // تحميل أولي
        if (state is CartInitial || state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // لما الكارت فيها منتجات
        if (state is CartUpdated) {
          print("cart items________________:${state.items.length}");
          return CartViewBody(items: state.items);
        }

        // لو خيار توصيل اختير → ما نخسر السلة
        if (state is CartDeliveryOptionSelected) {
          return CartViewBody(items: state.items);
        }

        // لو مافي ولا حالة من فوق:
        return const Center(child: Text("السلة فارغة ☕️"));
      },
    );
  }
}
