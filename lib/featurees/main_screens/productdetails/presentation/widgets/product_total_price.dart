// import 'package:appp/featurees/main_screens/productdetails/presentation/views/product_details_view.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../home/presentation/widgets/add_to_cart_button.dart';
// import '../../../../../utils/app_style.dart';
// import '../cubit/product_details_cubit.dart';
// import '../cubit/product_details_state.dart';

// class ProductTotalPrice extends StatelessWidget {
//   const ProductTotalPrice({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
//       builder: (context, state) {
//         if (state is! ProductDetailsLoaded) return const SizedBox.shrink();
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 5),
//                   child: Text("Total Price", style: AppStyles.InriaSerif_14),
//                 ),
//                 Text(
//                   "\$${state.totalPrice.toStringAsFixed(2)}",
//                   style: AppStyles.titleLora18.copyWith(
//                     color: AppColors.onPressedColor,
//                   ),
//                 ),
//               ],
//             ),
//             AddToCartButton(text: 'Add to Cart', onPressed: () {}),
//           ],
//         );
//       },
//     );
//   }
// }
