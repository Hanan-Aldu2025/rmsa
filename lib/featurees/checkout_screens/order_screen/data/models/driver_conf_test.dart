import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_cubit.dart';
class DeliveryConfirmationPage extends StatelessWidget {
  final String orderId;

  const DeliveryConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'هل ترغب في قبول هذا الطلب؟',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // عند القبول
                  context.read<OrderTrackingCubit>().updateOrderStatus(
                    orderId: orderId,
                    newStatus: 'accepted',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم قبول الطلب")),
                  );
                  // لا حاجة للانتقال هنا
                },
                child: const Text('قبول'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // عند الرفض
                  context.read<OrderTrackingCubit>().updateOrderStatus(
                    orderId: orderId,
                    newStatus: 'rejected',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم رفض الطلب")),
                  );
                  // لا حاجة للانتقال هنا
                },
                child: const Text('رفض'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}