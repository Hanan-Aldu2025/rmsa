import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_card_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';

class CustomBodyItemListView extends StatelessWidget {
  final List<CartItemEntity> items;

  const CustomBodyItemListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'السلة فارغة ☕️',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;

        String details = '';
        if (item.selectedOptions != null && item.selectedOptions!.isNotEmpty) {
          details = item.selectedOptions!.entries
              .map((e) => '${e.value}')
              .join(', ');
        }

        return CustomCardListView(
          product: product,
          cartCubit: cartCubit,
          item: item,
          details: details,
        );
      },
    );
  }
}
