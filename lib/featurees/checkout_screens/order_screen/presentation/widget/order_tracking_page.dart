
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_conf_test.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_order_test_ui.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_states.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/custom_driver_inf.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/custom_order_summary.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/custom_progress_overview.dart';
import 'package:appp/featurees/maps/delivery_map.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});
  static const routeName = "OrderTrackingPage";
  bool showTracking(String status) {
    return status != 'pending' && status != 'rejected';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderTrackingCubit()..startTrackingLastOrder(),
      child: Scaffold(
        appBar: buildAppBar(context, title: S.of(context).orderTracking),
        body: BlocConsumer<OrderTrackingCubit, OrderTrackingState>(
          listener: (context, state) {
            if (state is OrderTrackingError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is OrderTrackingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderTrackingLoaded) {
              final order = state.order;
              final orderId =
                  order.id; // الحصول على orderId من البيانات المحملة
              final orderStatus = order.orderStatus;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrderSummaryCard(order: order),
                        const SizedBox(height: 16),

                        // عرض صفحة تأكيد القبول داخل نفس الصفحة إذا كان في حالة انتظار
                        if (orderStatus == 'pending') ...[
                          DeliveryConfirmationPage(
                            orderId: orderId,
                          ), // تضمين صفحة قبول/رفض الطلب هنا
                        ],

                        // عرض بيانات السائق إذا تم قبول الطلب
                        if (showTracking(orderStatus!)) ...[
                          CustomOrderProgressOverview(),
                          const SizedBox(height: 16),
                          DeliveryDriverCard(), // عرض بيانات السائق هنا
                          const SizedBox(height: 16),
                          DriverStatusScreen(
                            orderId: orderId,
                          ), // عرض حالة السائق
                          SizedBox(height: 300, child: DeliveryTrackingPage(orderId: orderId,)),
                        ],

                        // عرض رسالة في حالة الرفض
                        if (orderStatus == 'rejected') ...[
                          Text(
                            S.of(context).orderRejectedByDriver,
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
