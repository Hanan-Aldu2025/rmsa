import 'package:appp/featurees/checkout_screens/order_screen/domain/use_case/order_use_case.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/use_case/payment_use_case.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_cubit/order_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/order_view_bloc_counsumer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(
        createOrderUseCase: CreateOrderUseCase(context.read()),
        updatePaymentUseCase: UpdatePaymentUseCase(context.read()),
      ),
      child: const OrderViewBlocConsumer(),
    );
  }
}
