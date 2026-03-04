// lib/featurees/main_screens/product_details/presentation/views/widgets/product_image_section.dart

import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/custom_button_back.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// قسم صورة المنتج في صفحة التفاصيل
class ProductImageSection extends StatelessWidget {
  final String imageUrl;

  const ProductImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[100]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),

        // زر الرجوع
        const CustomButtonBack(),
      ],
    );
  }
}
