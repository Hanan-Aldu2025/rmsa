import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderEntity order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return CustomBorderContainer(
      mychild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${S.of(context).orders} ${order.id}" , style: AppStyles.titleLora14),
          const SizedBox(height: 8),

          Text(
            order.items.map((e) => "${e.quantity} ${e.name}").join(", "),
            style: AppStyles.InriaSerif_14,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${S.of(context).orderTotal} ${order.totalAmount.toStringAsFixed(2)}",
                style: AppStyles.textLora16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
