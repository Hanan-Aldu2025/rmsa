// import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_process_overview_cubit/order_process_overview_cubit.dart';
// import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_process_overview_cubit/order_process_overview_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AdminOrderTestPage extends StatelessWidget {
//   final String orderId;

//   const AdminOrderTestPage({super.key, required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ProcessOverviewCubit()..loadOrder(orderId),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Admin Order Control")),
//         body: BlocConsumer<ProcessOverviewCubit, ProcessOverviewState>(
//           listener: (context, state) {
//             if (state is UpdateOrderStatusSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("تم تحديث الحالة إلى ${state.newStatus}")),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is ProcessOverviewLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is ProcessOverviewLoaded) {
//               final order = state.orderData;

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Order ID: $orderId"),
//                   Text("Current Status: ${order['orderStatus']}"),
//                   const SizedBox(height: 20),

//                   _statusButton(context, "confirmed"),
//                   _statusButton(context, "preparing"),
//                   _statusButton(context, "on_the_way"),
//                   _statusButton(context, "delivered"),
//                   _statusButton(context, "canceled"),
//                 ],
//               );
//             }

//             if (state is ProcessOverviewError) {
//               return Center(child: Text(state.message));
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _statusButton(BuildContext context, String status) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: ElevatedButton(
//         onPressed: () {
//           context.read<ProcessOverviewCubit>().updateOrderStatus(
//                 orderId: orderId,
//                 newStatus: status,
//               );
//         },
//         child: Text(status.toUpperCase()),
//       ),
//     );
//   }
// }