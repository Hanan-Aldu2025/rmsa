// import 'package:appp/featurees/main_screens/productdetails/presentation/views/product_details_view.dart';
// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get_utils/src/extensions/context_extensions.dart';

// import '../../../home/data/models/product_model.dart';
// import '../cubit/product_details_cubit.dart';
// import '../cubit/product_details_state.dart';

// class ProductSizeSelector extends StatelessWidget {
//   final List<ProductSize> sizes;
//   const ProductSizeSelector({super.key, required this.sizes});

//   @override
//   Widget build(BuildContext context) {
//     // final screenWidth = MediaQuery.of(context).size.width;
//     // final screenHeight = MediaQuery.of(context).size.height;

//     return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
//       builder: (context, state) {
//         if (state is! ProductDetailsLoaded) return const SizedBox.shrink();

//         final cubit = context.read<ProductDetailsCubit>();
//         final selected = state.selectedSize;

//         // التحقق من الحجم الواحد
//         if (sizes.length == 1 && sizes.first.size.toLowerCase() == "onesize") {
//           return const SizedBox.shrink();
//         }

//         return Wrap(
//           spacing: context.width * 0.010,
//           runSpacing: context.height * 0.015,
//           // هنا استخدمنا sizes مباشرة لأن الـ Cubit قام بترتيبها في الذاكرة
//           children: sizes.map((s) {
//             final isSelected = s.size == selected;
//             return GestureDetector(
//               onTap: () => cubit.selectSize(s.size),
//               child: Container(
//                 width: context.width * 0.3, // عرض المربع
//                 padding: EdgeInsets.all(context.width * 0.025),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: isSelected
//                         ? AppColors.primaryColor
//                         : AppColors.borderColor,
//                     width: isSelected ? 2 : 1,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   color: AppColors.whiteColor,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         // دائرة الاختيار (Radio Button)
//                         Container(
//                           width: context.width * 0.045,
//                           height: context.height * 0.045,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isSelected
//                                   ? AppColors.primaryColor
//                                   : Colors.grey.shade400,
//                               width: 2,
//                             ),
//                           ),
//                           child: isSelected
//                               ? Center(
//                                   child: Container(
//                                     width: context.width * 0.025,
//                                     height: context.height * 0.025,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.onPressedColor,
//                                     ),
//                                   ),
//                                 )
//                               : null,
//                         ),
//                         SizedBox(width: 10),
//                         // اسم الحجم (Small, Medium...)
//                         Text(s.label, style: AppStyles.InriaSerif_16),
//                       ],
//                     ),
//                     // SizedBox(height: 5),
//                     // عرض الـ oz
//                     if (s.sizeOz != null)
//                       Center(
//                         child: Text(
//                           "${s.sizeOz} oz",
//                           style: AppStyles.InriaSerif_14,
//                         ),
//                       ),
//                     SizedBox(height: 5),
//                     // السعر
//                     Center(
//                       child: Text(
//                         "\$${s.price.toStringAsFixed(2)}",
//                         style: AppStyles.InriaSerif_16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(), // تحويل الـ map إلى قائمة ويدجت
//         );
//       },
//     );
//   }
// }
