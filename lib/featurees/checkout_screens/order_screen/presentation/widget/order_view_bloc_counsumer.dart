import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_cubit/order_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_cubit/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/order_tracking_page.dart';

class OrderViewBlocConsumer extends StatelessWidget {
  const OrderViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OrdersLoaded && state.orders.isNotEmpty) {
          return OrderTrackingPage();
        }

        return const Center(child: Text('لا يوجد طلبات حالياً ☕'));
      },
    );
  }
}
