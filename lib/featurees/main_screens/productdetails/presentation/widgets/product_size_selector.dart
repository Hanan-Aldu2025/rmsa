// lib/featurees/main_screens/product_details/presentation/views/widgets/product_size_selector.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_cubit.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_state.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

/// منتقي حجم المنتج
class ProductSizeSelector extends StatelessWidget {
  final List<ProductSizeEntity> sizes;

  const ProductSizeSelector({super.key, required this.sizes});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is! ProductDetailsLoaded) return const SizedBox.shrink();

        final cubit = context.read<ProductDetailsCubit>();
        final selected = state.selectedSize;

        // التحقق من الحجم الواحد
        if (sizes.length == 1 && sizes.first.size.toLowerCase() == "onesize") {
          return const SizedBox.shrink();
        }

        return Wrap(
          spacing: context.width * 0.01,
          runSpacing: context.height * 0.015,
          children: sizes.map((s) {
            final isSelected = s.size == selected;

            return GestureDetector(
              onTap: () => cubit.selectSize(s.size),
              child: Container(
                width: context.width * 0.3,
                padding: EdgeInsets.all(context.width * 0.025),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // دائرة الاختيار
                        Container(
                          width: context.width * 0.045,
                          height: context.height * 0.045,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: context.width * 0.025,
                                    height: context.height * 0.025,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),

                        // اسم الحجم
                        Text(s.label),
                      ],
                    ),

                    // عرض الـ oz
                    if (s.sizeOz != null) Center(child: Text("${s.sizeOz} oz")),

                    const SizedBox(height: 5),

                    // السعر
                    Center(child: Text("${s.price.toStringAsFixed(2)} ر.س")),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
