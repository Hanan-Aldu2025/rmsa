// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../cubit/product_details_cubit.dart';
// import 'product_extra_options.dart';
// import 'product_image_section.dart';
// import 'product_note_field.dart';
// import 'product_size_selector.dart';
// import 'product_total_price.dart';

// class ProductDetailsViewBody extends StatelessWidget {
//   const ProductDetailsViewBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context); // استدعاء الترجمة

//     final cubit = context.read<ProductDetailsCubit>();
//     final product = cubit.product;

//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ProductImageSection(imageUrl: product.imageUrl),
//                 const SizedBox(height: 16),

//                 Text(product.name, style: AppStyles.titleLora24),
//                 const SizedBox(height: 8),
//                 Text(
//                   product.description,
//                   style: AppStyles.InriaSerif_16.copyWith(
//                     color: AppColors.GrayIconColor,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(lang.selectSize, style: AppStyles.titleLora18),
//                 SizedBox(height: 10),
//                 ProductSizeSelector(sizes: product.sizes),
//                 const SizedBox(height: 24),
//                 ProductExtraOptions(options: cubit.extraOptions),
//                 // const SizedBox(height: 24),
//                 // const ProductNoteField(
//                 //   title: '"Add your note"',
//                 //   hitText: 'Write your note',
//                 // ),
//               ],
//             ),
//           ),
//         ),
//         const Divider(),
//         Container(
//           padding: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             top: 8,
//             bottom: 16,
//           ),
//           color: AppColors.whiteColor,
//           child: const ProductTotalPrice(),
//         ),
//       ],
//     );
//   }
// }
