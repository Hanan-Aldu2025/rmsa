import 'package:appp/featurees/main_screens/productdetails/data/model/extra_option_item_model.dart';
import 'package:equatable/equatable.dart';

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
