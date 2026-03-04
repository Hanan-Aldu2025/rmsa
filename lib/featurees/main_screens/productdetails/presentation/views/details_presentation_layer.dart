// lib/featurees/main_screens/product_details/presentation/cubit/product_details_state.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/widgets/add_to_cart_button.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// حالات صفحة تفاصيل المنتج
abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class ProductDetailsInitial extends ProductDetailsState {}

/// الحالة بعد تحميل البيانات
class ProductDetailsLoaded extends ProductDetailsState {
  final String? selectedSize;
  final double totalPrice;
  final List<ExtraOptionItemModel> extraOptions;

  const ProductDetailsLoaded({
    required this.selectedSize,
    required this.totalPrice,
    required this.extraOptions,
  });

  @override
  List<Object?> get props => [selectedSize, totalPrice, extraOptions];
}

// lib/featurees/main_screens/product_details/presentation/cubit/extra_option_item_model.dart

/// موديل الخيارات الإضافية للتفاعل مع واجهة المستخدم
class ExtraOptionItemModel {
  final String label;
  final double price;
  final ValueNotifier<bool> isChecked;

  ExtraOptionItemModel({required this.label, required this.price})
    : isChecked = ValueNotifier(false);

  @override
  String toString() => 'ExtraOptionItemModel(label: $label, price: $price)';
}

// lib/featurees/main_screens/product_details/presentation/cubit/product_details_cubit.dart

/// Cubit المسؤول عن منطق صفحة تفاصيل المنتج
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductEntity product;
  String? selectedSize;
  double totalPrice = 0;
  late List<ExtraOptionItemModel> extraOptions;

  ProductDetailsCubit(this.product) : super(ProductDetailsInitial()) {
    _initialize();
  }

  /// تهيئة البيانات
  void _initialize() {
    // ترتيب الأحجام حسب السعر
    if (product.sizes.isNotEmpty) {
      final sortedSizes = List.from(product.sizes)
        ..sort((a, b) => a.price.compareTo(b.price));
      selectedSize = sortedSizes.first.size;
      totalPrice = sortedSizes.first.price;
    } else {
      totalPrice = product.price;
    }

    // تهيئة الخيارات الإضافية
    extraOptions = product.extraOption
        .where((e) => e.option.toLowerCase() != 'nooption')
        .map((e) => ExtraOptionItemModel(label: e.option, price: e.price ?? 0))
        .toList();

    // الاستماع لتغييرات الخيارات
    for (var option in extraOptions) {
      option.isChecked.addListener(_recalculateTotal);
    }

    _emitLoaded();
  }

  /// إعادة حساب السعر الإجمالي
  void _recalculateTotal() {
    double sizePrice = product.price;

    if (selectedSize != null && product.sizes.isNotEmpty) {
      final selectedSizeObj = product.sizes.firstWhere(
        (s) => s.size == selectedSize,
        orElse: () => product.sizes.first,
      );
      sizePrice = selectedSizeObj.price;
    }

    final extras = extraOptions
        .where((e) => e.isChecked.value)
        .fold(0.0, (sum, e) => sum + e.price);

    totalPrice = (sizePrice + extras);
    _emitLoaded();
  }

  /// اختيار حجم معين
  void selectSize(String size) {
    selectedSize = size;
    _recalculateTotal();
  }

  /// إرسال الحالة المحدثة
  void _emitLoaded() {
    emit(
      ProductDetailsLoaded(
        selectedSize: selectedSize,
        totalPrice: totalPrice,
        extraOptions: extraOptions,
      ),
    );
  }

  @override
  Future<void> close() {
    // التخلص من المستمعين
    for (var option in extraOptions) {
      option.isChecked.dispose();
    }
    return super.close();
  }
}

// lib/featurees/main_screens/product_details/presentation/views/product_details_view.dart

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
// lib/featurees/main_screens/product_details/presentation/views/product_details_view_consumer.dart

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

// lib/featurees/main_screens/product_details/presentation/views/product_details_view_body.dart

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

// lib/featurees/main_screens/product_details/presentation/views/widgets/product_image_section.dart

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

// lib/featurees/main_screens/product_details/presentation/views/widgets/custom_button_back.dart

/// زر الرجوع المخصص
class CustomButtonBack extends StatelessWidget {
  const CustomButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 20,
      start: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: CircleAvatar(
          backgroundColor: AppColors.whiteColor.withOpacity(0.8),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.blackColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// lib/featurees/main_screens/product_details/presentation/views/widgets/product_size_selector.dart

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

// lib/featurees/main_screens/product_details/presentation/views/widgets/product_extra_options.dart

/// قسم الخيارات الإضافية
class ProductExtraOptions extends StatelessWidget {
  final List<ExtraOptionItemModel> options;

  const ProductExtraOptions({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.extraOptions, style: AppStyles.titleLora18),
        const SizedBox(height: 8),
        ...options.map((opt) {
          return ValueListenableBuilder<bool>(
            valueListenable: opt.isChecked,
            builder: (_, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: value,
                      activeColor: AppColors.primaryColor,
                      onChanged: (v) => opt.isChecked.value = v!,
                    ),
                    Text(opt.label, style: AppStyles.InriaSerif_14),
                  ],
                ),
                Text(
                  "${opt.price.toStringAsFixed(2)} ${lang.sar}",
                  style: AppStyles.InriaSerif_14,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

// lib/featurees/main_screens/product_details/presentation/views/widgets/product_bottom_bar.dart

/// الشريط السفلي مع السعر وزر الإضافة
class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      color: Colors.white,
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is! ProductDetailsLoaded) return const SizedBox.shrink();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.totalPrice, style: AppStyles.InriaSerif_14),
                  Text(
                    isAr
                        ? "${state.totalPrice.toStringAsFixed(2)} ${lang.sar}"
                        : "${state.totalPrice.toStringAsFixed(2)} ${lang.sar}",
                    style: AppStyles.titleLora18.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              AddToCartButton(
                text: lang.addToCart,
                onPressed: () {
                  // منطق إضافة إلى السلة
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
