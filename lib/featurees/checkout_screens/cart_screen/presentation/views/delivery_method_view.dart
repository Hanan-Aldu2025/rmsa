import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/order_method_cubit/order_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryMethodView extends StatelessWidget {
  final double cartTotal;

  const DeliveryMethodView({super.key, required this.cartTotal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار طريقة الاستلام')),
      body: BlocProvider(
        create: (_) => getIt<DeliveryMethodCubit>(),
        // child: DeliveryMethodBody(cartTotal: cartTotal),
      ),
    );
  }
}
