// import 'package:appp/core/services/get_it_services.dart';
// import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
// import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/card_cubit/card_payment_cubit.dart';
// import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cash_cubit/cash_payment_cubit.dart';
// import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cubit_payment_method/payment_method_cubit.dart';
// import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/mobile_wallet_cubit/moile_wallet_cubit.dart';
// import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/payment_method_consumer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CheckoutRoot extends StatelessWidget {
//   const CheckoutRoot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // السلة (واحدة فقط)
//         BlocProvider(create: (_) => getIt<CartCubit>()),

//         // طريقة الدفع
//         BlocProvider(create: (_) => PaymentMethodCubit()),

//         // كاش
//         BlocProvider(
//           create: (_) => CashPaymentCubit(getIt<CartCubit>()),
//         ),

//         // كرت
//         BlocProvider(create: (_) => getIt<CardPaymentCubit>()),

//         // محفظة
//         BlocProvider(create: (_) => getIt<MobilePaymentCubit>()),
//       ],
//       child: const PaymentMethodConsumer(), // 👈 UI فقط
//     );
//   }
// }