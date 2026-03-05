import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriverStatusScreen extends StatelessWidget {
  final String orderId;

  DriverStatusScreen({super.key, required this.orderId});

  Future<void> updateOrderStatus(String status) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'orderStatus': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  final List<String> statuses = [
    'confirmed',
    'preparing',
    'on_the_way',
    'delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final currentStatus = data['orderStatus'];

        int currentIndex = statuses.indexOf(currentStatus);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(statuses.length, (index) {
            final status = statuses[index];

            bool isCompleted = index <= currentIndex;
            bool isNext = index == currentIndex + 1;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted
                      ? Colors.green
                      : Colors.grey.shade400,
                ),
                onPressed: isNext ? () => updateOrderStatus(status) : null,
                child: Text(getArabicLabel(status)),
              ),
            );
          }),
        );
      },
    );
  }

  String getArabicLabel(String status) {
    switch (status) {
      case 'confirmed':
        return "تم التأكيد";
      case 'preparing':
        return "قيد التحضير";
      case 'on_the_way':
        return "في الطريق";
      case 'delivered':
        return "تم التوصيل";
      default:
        return status;
    }
  }
}

class DriverOrderSelectionScreen extends StatelessWidget {
  Future<String> getOrderId() async {
    // هنا يمكنك إضافة الكود لجلب orderId من Firebase
    var orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .limit(1)
        .orderBy('createdAt', descending: true)
        .get();

    if (orderSnapshot.docs.isNotEmpty) {
      return orderSnapshot.docs.first.id;
    } else {
      throw Exception("No orders found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getOrderId(), // جلب orderId من Firebase
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No orders found'));
        }

        final orderId = snapshot.data!; // الحصول على orderId
        return DriverStatusScreen(
          orderId: orderId,
        ); // عرض الشاشة باستخدام orderId
      },
    );
  }
}
