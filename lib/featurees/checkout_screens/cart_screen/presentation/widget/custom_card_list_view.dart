import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/utils/app_style.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'custom_add_remove_row.dart';

class CustomCardListView extends StatelessWidget {
  final ProductEntity product;
  final CartCubit cartCubit;
  final CartItemEntity item;
  final String details;

  const CustomCardListView({
    super.key,
    required this.product,
    required this.cartCubit,
    required this.item,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return CustomBorderContainer(
      myheight: screenHeight * 0.14, // 5% من ارتفاع الشاشة
      mywidth: screenWidth * 0.20, // 10

      mychild: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                product.imageUrl,
                width: 80,
                height: 80, // ← عدّل كما تريد
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppStyles.InriaSerif_16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ${product.selectedSize}',
                        style: AppStyles.InriaSerif_14,
                      ),
                      GestureDetector(
                        onTap: () {
                          cartCubit.removeProduct(
                            product,
                            selectedOptions: item.selectedOptions,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            LucideIcons.trash2,
                            size: 24,
                            color: AppColors.GrayIconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (details.isNotEmpty)
                    Text(
                      details,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(height: 5),
                  CustomAddRemoveRow(
                    product: product,
                    cartCubit: cartCubit,
                    item: item,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
