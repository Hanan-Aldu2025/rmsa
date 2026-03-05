import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/repo_imp/driver_repo_imp.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/card_cubit/card_payment_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cash_cubit/cash_payment_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cubit_payment_method/payment_method_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/mobile_wallet_cubit/moile_wallet_cubit.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/payment_method_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodConsumer extends StatelessWidget {
  const PaymentMethodConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider<PaymentMethodCubit>(create: (_) => PaymentMethodCubit()),
        BlocProvider.value(value: getIt<CardPaymentCubit>()),
        BlocProvider.value(value: getIt<MobilePaymentCubit>()),

        // ✅ أهم سطر: CashPaymentCubit موجود هنا فوق PaymentMethodBody
        BlocProvider<CashPaymentCubit>(
          create: (_) => CashPaymentCubit(getIt<CartCubit>(),getIt<DriverRepository>()),
        ),
      ],
      child: const PaymentMethodBody(),
    );
  }
}