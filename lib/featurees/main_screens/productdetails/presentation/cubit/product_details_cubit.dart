// import 'package:appp/featurees/main_screens/productdetails/data/model/extra_option_item_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../home/data/models/product_model.dart';
// import 'product_details_state.dart';

// class ProductDetailsCubit extends Cubit<ProductDetailsState> {
//   ProductDetailsCubit(this.product) : super(ProductDetailsInitial()) {
//     _initialize();
//   }

//   final ProductModel product;
//   String? selectedSize;
//   double totalPrice = 0;
//   late List<ExtraOptionItemModel> extraOptions;
//   void _initialize() {
//     if (product.sizes.isNotEmpty) {
//       // ترتيب القائمة بناءً على السعر (من الأرخص للأغلى)
//       // هذا يضمن أن Small يظهر أولاً لأنه عادة الأرخص
//       product.sizes.sort((a, b) => a.price.compareTo(b.price));

//       // اختيار الحجم الأرخص كافتراضي
//       selectedSize = product.sizes.first.size;
//       totalPrice = product.sizes.first.price;
//     }

//     extraOptions = product.extraOption
//         .where((e) => e.option.toLowerCase() != 'nooption')
//         .map((e) => ExtraOptionItemModel(label: e.option, price: e.price ?? 0))
//         .toList();

//     for (var option in extraOptions) {
//       option.isChecked.addListener(_recalculateTotal);
//     }

//     emit(
//       ProductDetailsLoaded(
//         selectedSize: selectedSize,
//         totalPrice: totalPrice,
//         extraOptions: extraOptions,
//       ),
//     );
//   }

//   void _recalculateTotal() {
//     if (state is! ProductDetailsLoaded) return;

//     double sizePrice = 0;
//     if (selectedSize != null) {
//       final size = product.sizes.firstWhere(
//         (s) => s.size == selectedSize,
//         orElse: () => product.sizes.first,
//       );
//       sizePrice = size.price;
//     }

//     double extras = extraOptions
//         .where((e) => e.isChecked.value)
//         .fold(0, (sum, e) => sum + e.price);

//     totalPrice = sizePrice + extras;

//     emit(
//       ProductDetailsLoaded(
//         selectedSize: selectedSize,
//         totalPrice: totalPrice,
//         extraOptions: extraOptions,
//       ),
//     );
//   }

//   void selectSize(String size) {
//     selectedSize = size;
//     _recalculateTotal();
//   }

//   @override
//   Future<void> close() {
//     for (var option in extraOptions) {
//       option.isChecked.removeListener(_recalculateTotal);
//       option.isChecked.dispose();
//     }
//     return super.close();
//   }
// }
