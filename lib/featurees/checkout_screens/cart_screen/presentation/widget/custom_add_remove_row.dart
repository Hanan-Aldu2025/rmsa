import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/utils/app_style.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';

class CustomAddRemoveRow extends StatelessWidget {
  final ProductEntity product;
  final CartCubit cartCubit;
  final CartItemEntity item;

  const CustomAddRemoveRow({
    super.key,
    required this.product,
    required this.cartCubit,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Text(
          "\$${product.price.toStringAsFixed(2)}",
          style: AppStyles.InriaSerif_14,
        ),
        const SizedBox(width: 35),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomBorderContainer(
              myheight: screenHeight * 0.04, // 5% من ارتفاع الشاشة
              mywidth: screenWidth * 0.085, // 10% من عرض الشاش
              mychild: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.remove, size: 20, color: AppColors.blackColor),
                onPressed: () {
                  cartCubit.decreaseProduct(
                    product,
                    selectedOptions: item.selectedOptions,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${item.quantity}",
              style: AppStyles.InriaSerif_16.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            CustomBorderContainer(
              myheight: screenHeight * 0.04,
              mywidth: screenWidth * 0.085,
              mychild: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.add, size: 20, color: AppColors.blackColor),
                onPressed: () {
                  cartCubit.addProduct(
                    product,
                    selectedOptions: item.selectedOptions,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
