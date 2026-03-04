// import 'package:appp/featurees/main_screens/productdetails/data/model/extra_option_item_model.dart';
// import 'package:appp/featurees/main_screens/productdetails/presentation/views/product_details_view.dart';
// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:flutter/material.dart';

// class ProductExtraOptions extends StatelessWidget {
//   final List<ExtraOptionItemModel> options;
//   const ProductExtraOptions({super.key, required this.options});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context); // استدعاء الترجمة
//     if (options.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(lang.extraOptions, style: AppStyles.titleLora18),
//         const SizedBox(height: 8),
//         Column(
//           children: options.map((opt) {
//             return ValueListenableBuilder<bool>(
//               valueListenable: opt.isChecked,
//               builder: (_, value, __) => Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: value,
//                         activeColor: AppColors.borderColor,
//                         onChanged: (v) => opt.isChecked.value = v!,
//                       ),
//                       Text(opt.label, style: AppStyles.InriaSerif_14),
//                     ],
//                   ),
//                   Text(
//                     "\$${opt.price.toStringAsFixed(2)}",
//                     style: AppStyles.InriaSerif_14,
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
