// lib/featurees/main_screens/product_details/presentation/views/product_details_view_body.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_cubit.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_bottom_bar.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_extra_options.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_image_section.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_size_selector.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جسم صفحة تفاصيل المنتج
class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final cubit = context.read<ProductDetailsCubit>();
    final product = cubit.product;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة المنتج
                    ProductImageSection(imageUrl: product.imageUrl),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kHorizintalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اسم المنتج
                          Text(
                            isAr ? product.nameAr : capitalize(product.name),
                            style: AppStyles.titleLora24,
                          ),
                          const SizedBox(height: 8),

                          // وصف المنتج
                          Text(
                            isAr ? product.descriptionAr : product.description,
                            textAlign: TextAlign.justify,
                            style: AppStyles.InriaSerif_16.copyWith(
                              color: AppColors.GrayIconColor,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // اختيار الحجم
                          if (product.sizes.isNotEmpty) ...[
                            Text(lang.selectSize, style: AppStyles.titleLora18),
                            const SizedBox(height: 10),
                            ProductSizeSelector(sizes: product.sizes),
                            const SizedBox(height: 24),
                          ],

                          // الخيارات الإضافية
                          ProductExtraOptions(options: cubit.extraOptions),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // الشريط السفلي
            const ProductBottomBar(),
          ],
        ),
      ),
    );
  }
}
