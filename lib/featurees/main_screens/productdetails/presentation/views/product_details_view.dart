// lib/featurees/main_screens/product_details/presentation/views/product_details_view.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_cubit.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_details_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة تفاصيل المنتج - نقطة الدخول
class ProductDetailsView extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // إخفاء لوحة المفاتيح
    FocusManager.instance.primaryFocus?.unfocus();

    return BlocProvider(
      create: (_) => ProductDetailsCubit(product),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: ProductDetailsViewConsumer(),
      ),
    );
  }
}
