// lib/featurees/main_screens/product_details/presentation/cubit/product_details_cubit.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/productdetails/data/model/extra_option_item_model.dart';
import 'package:appp/featurees/main_screens/productdetails/presentation/cubit/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
