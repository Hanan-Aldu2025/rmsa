// lib/featurees/main_screens/product_details/presentation/views/product_details_view_consumer.dart

import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_cubit.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_state.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class ProductDetailsViewConsumer extends StatelessWidget {
  const ProductDetailsViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final isLoading = state is ProductDetailsInitial;
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: const ProductDetailsViewBody(),
        );
      },
    );
  }
}
