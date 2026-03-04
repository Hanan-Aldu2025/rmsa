// import 'package:appp/core/constans/constans_kword.dart';
// import 'package:appp/featurees/main_screens/home/presentation/widgets/add_to_cart_button.dart';
// import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_state.dart';
// import 'package:appp/featurees/main_screens/productdetails/presentation/widgets/product_size_selector.dart';
// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../home/data/models/product_model.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// class ProductDetailsView extends StatelessWidget {
//   final ProductModel product;
//   const ProductDetailsView({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     FocusManager.instance.primaryFocus
//         ?.unfocus(); // إخفاء لوحة المفاتيح إذا كانت مفتوحة
//     return BlocProvider(
//       create: (_) => ProductDetailsCubit(product),
//       child: const Scaffold(
//         backgroundColor: Colors.white,
//         body: ProductDetailsBlocConsumer(),
//       ),
//     );
//   }
// }

// class ProductDetailsBlocConsumer extends StatelessWidget {
//   const ProductDetailsBlocConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
//       builder: (context, state) {
//         final isLoading = state is ProductDetailsInitial;
//         return ModalProgressHUD(
//           inAsyncCall: isLoading,
//           child: const ProductDetailsViewBody(),
//         );
//       },
//     );
//   }
// }

// class ProductDetailsViewBody extends StatelessWidget {
//   const ProductDetailsViewBody({super.key});

//   // دالة تنسيق النص: أول حرف كابيتال والباقي سمول
//   String _formatText(String text) {
//     if (text.isEmpty) return text;
//     return text
//         .split(' ')
//         .map((word) {
//           if (word.isEmpty) return word;
//           return word[0].toUpperCase() + word.substring(1).toLowerCase();
//         })
//         .join(' ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);
//     final isAr = Localizations.localeOf(context).languageCode == 'ar';
//     final cubit = context.read<ProductDetailsCubit>();
//     final product = cubit.product;

//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 // physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ProductImageSection(imageUrl: product.imageUrl),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: kHorizintalPadding,
//                         // horizontal: 5,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // الاسم المترجم والمنسق
//                           Text(
//                             isAr ? product.nameAr : _formatText(product.name),
//                             style: AppStyles.titleLora24,
//                           ),
//                           const SizedBox(height: 8),
//                           // الوصف المترجم والمنسق
//                           // Text(
//                           //   isAr
//                           //       ? product.descriptionAr
//                           //       : _formatText(product.description),
//                           //   style: AppStyles.InriaSerif_16.copyWith(
//                           //     color: AppColors.GrayIconColor,
//                           //   ),
//                           // ),
//                           Text(
//                             isAr
//                                 ? product.descriptionAr
//                                 : _formatText(product.description),
//                             textAlign: TextAlign
//                                 .justify, // 🔥 هذا السطر هو الذي يجعل الأسطر تنتهي بنفس الطول
//                             style: AppStyles.InriaSerif_16.copyWith(
//                               color: AppColors.GrayIconColor,
//                               height:
//                                   1.8, // إضافة مسافة بين الأسطر تعطي راحة للعين وفخامة أكثر
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           // إظهار قسم الحجم فقط إذا كانت القائمة غير فارغة
//                           if (product.sizes.isNotEmpty) ...[
//                             Text(lang.selectSize, style: AppStyles.titleLora18),
//                             const SizedBox(height: 10),
//                             ProductSizeSelector(sizes: product.sizes),
//                             const SizedBox(height: 24),
//                           ],

//                           ProductExtraOptions(options: cubit.extraOptions),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Divider(height: 1),
//             const ProductBottomBar(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductImageSection extends StatelessWidget {
//   final String imageUrl;
//   const ProductImageSection({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: 300,
//           // height: MediaQuery.of(context).size.height * 0.38,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             // border: Border.all(
//             //   color: AppColors.primaryColor.withOpacity(0.2),
//             //   width: 0.8,
//             // ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(color: Colors.grey[100]),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//           ),
//         ),
//         // زر الرجوع
//         CustomButtonBackDetailsView(),
//       ],
//     );
//   }
// }

// class CustomButtonBackDetailsView extends StatefulWidget {
//   const CustomButtonBackDetailsView({super.key});

//   @override
//   State<CustomButtonBackDetailsView> createState() =>
//       _CustomButtonBackDetailsViewState();
// }

// class _CustomButtonBackDetailsViewState
//     extends State<CustomButtonBackDetailsView> {
//   @override
//   Widget build(BuildContext context) {
//     return PositionedDirectional(
//       top: 20,
//       start: 16,
//       child: GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//           setState(() {});
//         },
//         child: CircleAvatar(
//           backgroundColor: AppColors.whiteColor.withOpacity(0.8),
//           child: const Icon(
//             Icons.arrow_back_ios_new,
//             color: AppColors.blackColor,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProductExtraOptions extends StatelessWidget {
//   final List<ExtraOptionItemModel> options;
//   const ProductExtraOptions({super.key, required this.options});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);
//     if (options.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(lang.extraOptions, style: AppStyles.titleLora18),
//         const SizedBox(height: 8),
//         ...options.map((opt) {
//           return ValueListenableBuilder<bool>(
//             valueListenable: opt.isChecked,
//             builder: (_, value, _) => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: value,
//                       activeColor: AppColors.borderColor,
//                       onChanged: (v) => opt.isChecked.value = v!,
//                     ),
//                     Text(opt.label, style: AppStyles.InriaSerif_14),
//                   ],
//                 ),
//                 Text(
//                   "${opt.price.round().toInt()} ${lang.sar}",
//                   style: AppStyles.InriaSerif_14,
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }
// }

// class ProductBottomBar extends StatelessWidget {
//   const ProductBottomBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);
//     final isAr = Localizations.localeOf(context).languageCode == 'ar';

//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
//       color: Colors.white,
//       child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
//         builder: (context, state) {
//           if (state is! ProductDetailsLoaded) return const SizedBox.shrink();
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(lang.totalPrice, style: AppStyles.InriaSerif_14),
//                   Text(
//                     isAr
//                         ? "${state.totalPrice} ${lang.sar}"
//                         : "${state.totalPrice} ${lang.sar}",
//                     style: AppStyles.titleLora18.copyWith(
//                       color: AppColors.onPressedColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               AddToCartButton(
//                 text: lang.addToCart,
//                 onPressed: () {
//                   // منطق السلة
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class ExtraOptionItemModel {
//   final String label;
//   final double price;
//   final ValueNotifier<bool> isChecked = ValueNotifier(false);
//   ExtraOptionItemModel({required this.label, required this.price});
// }

// class ProductDetailsCubit extends Cubit<ProductDetailsState> {
//   final ProductModel product;
//   String? selectedSize;
//   double totalPrice = 0; // تم تحويله لـ int
//   late List<ExtraOptionItemModel> extraOptions;

//   ProductDetailsCubit(this.product) : super(ProductDetailsInitial()) {
//     _initialize();
//   }

//   void _initialize() {
//     if (product.sizes.isNotEmpty) {
//       product.sizes.sort((a, b) => a.price.compareTo(b.price));
//       selectedSize = product.sizes.first.size;
//       totalPrice = product.sizes.first.price.roundToDouble();
//     } else {
//       totalPrice = product.price.roundToDouble();
//     }

//     extraOptions = product.extraOption
//         .where((e) => e.option.toLowerCase() != 'nooption')
//         .map((e) => ExtraOptionItemModel(label: e.option, price: e.price ?? 0))
//         .toList();

//     for (var option in extraOptions) {
//       option.isChecked.addListener(_recalculateTotal);
//     }
//     _emitLoaded();
//   }

//   void _recalculateTotal() {
//     double sizePrice = product.price;
//     if (selectedSize != null && product.sizes.isNotEmpty) {
//       sizePrice = product.sizes.firstWhere((s) => s.size == selectedSize).price;
//     }

//     double extras = extraOptions
//         .where((e) => e.isChecked.value)
//         .fold(0, (sum, e) => sum + e.price);

//     totalPrice = (sizePrice + extras).roundToDouble();
//     _emitLoaded();
//   }

//   void selectSize(String size) {
//     selectedSize = size;
//     _recalculateTotal();
//   }

//   void _emitLoaded() {
//     emit(
//       ProductDetailsLoaded(
//         selectedSize: selectedSize,
//         totalPrice: totalPrice,
//         extraOptions: extraOptions,
//       ),
//     );
//   }

//   @override
//   Future<void> close() {
//     for (var option in extraOptions) {
//       option.isChecked.dispose();
//     }
//     return super.close();
//   }
// }
