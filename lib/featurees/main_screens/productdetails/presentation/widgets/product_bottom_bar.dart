// lib/featurees/main_screens/product_details/presentation/views/widgets/product_bottom_bar.dart

import 'package:appp/featurees/main_screens/home/presentation/widgets/add_to_cart_button.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_cubit.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_state.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// الشريط السفلي مع السعر وزر الإضافة
class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      color: Colors.white,
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is! ProductDetailsLoaded) return const SizedBox.shrink();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.totalPrice, style: AppStyles.InriaSerif_14),
                  Text(
                    isAr
                        ? "${state.totalPrice.toStringAsFixed(2)} ${lang.sar}"
                        : "${state.totalPrice.toStringAsFixed(2)} ${lang.sar}",
                    style: AppStyles.titleLora18.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              AddToCartButton(
                text: lang.addToCart,
                onPressed: () {
                  // منطق إضافة إلى السلة
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
