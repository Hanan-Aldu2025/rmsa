// lib/featurees/main_screens/favorite/presentation/views/widgets/favorite_item_card.dart

import 'package:appp/featurees/main_screens/favorite/presentation/widgets/quantity_button.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// بطاقة عنصر المفضلة
class FavoriteItemCard extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const FavoriteItemCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGraybutton,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 12),

          // تفاصيل المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  langCode == 'ar' ? product.nameAr : product.name,
                  style: AppStyles.textLora16.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${product.price} ر.س',
                      style: AppStyles.InriaSerif_14.copyWith(fontSize: 15),
                    ),
                    const SizedBox(width: 12),

                    // زر الحذف من المفضلة
                    IconButton(
                      onPressed: onRemove,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // أزرار الكمية
          Row(
            children: [
              QuantityButton(icon: Icons.remove, onTap: onDecrease, size: 30),
              const SizedBox(width: 12),
              Text(
                quantity.toString(),
                style: AppStyles.titleLora18.copyWith(fontSize: 15),
              ),
              const SizedBox(width: 12),
              QuantityButton(icon: Icons.add, onTap: onIncrease, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
