import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cubit_payment_method/payment_method_cubit.dart';

import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/payment_method_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodView extends StatelessWidget {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentMethodCubit(),
      child: const PaymentMethodConsumer(),
    );
  }
}
