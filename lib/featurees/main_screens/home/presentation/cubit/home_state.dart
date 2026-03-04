import 'package:equatable/equatable.dart';
import '../../data/models/branch_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

// class HomeState extends Equatable {
//   final List<BranchModel> branches;
//   final BranchModel?
//   selectedBranch; // ✅ الفرع المختار الذي سيتم تمريره لصفحة التواصل
//   final List<CategoryModel> categories;
//   final String selectedCategoryId;
//   final List<ProductModel> products;
//   final bool loading;
//   final String searchQuery;
//   final String? errorMessage;

//   // الحقل الجديد لمعرفة حالة جلب الموقع الجغرافي
//   final bool isLocationLoading;

//   const HomeState({
//     this.branches = const [],
//     this.selectedBranch, // ✅ القيمة الافتراضية null
//     this.categories = const [],
//     this.selectedCategoryId = 'all',
//     this.products = const [],
//     this.loading = false,
//     this.searchQuery = '',
//     this.errorMessage,
//     this.isLocationLoading = false, // القيمة الافتراضية
//   });

//   HomeState copyWith({
//     List<BranchModel>? branches,
//     BranchModel? selectedBranch, // ✅ لإتاحة تحديث الفرع عند الاختيار
//     List<CategoryModel>? categories,
//     String? selectedCategoryId,
//     List<ProductModel>? products,
//     bool? loading,
//     String? searchQuery,
//     String? errorMessage,
//     bool? isLocationLoading, // إضافة هنا
//   }) {
//     return HomeState(
//       branches: branches ?? this.branches,
//       selectedBranch:
//           selectedBranch ??
//           this.selectedBranch, // ✅ يحافظ على القديم إذا لم نمرر جديداً
//       categories: categories ?? this.categories,
//       selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
//       products: products ?? this.products,
//       loading: loading ?? this.loading,
//       searchQuery: searchQuery ?? this.searchQuery,
//       errorMessage: errorMessage ?? this.errorMessage,
//       isLocationLoading:
//           isLocationLoading ?? this.isLocationLoading, // تحديث هنا
//     );
//   }

//   @override
//   List<Object?> get props => [
//     branches,
//     selectedBranch, // ✅ ضروري للمقارنة ليعرف Bloc أن الحالة تغيرت عند اختيار فرع جديد
//     categories,
//     selectedCategoryId,
//     products,
//     loading,
//     searchQuery,
//     errorMessage,
//     isLocationLoading, // إضافة هنا ليتم مقارنة الحالة بشكل صحيح
//   ];
// }
// نضع الـ enum خارج الكلاس ليكون قابلاً للاستخدام في الـ Cubit والواجهة

// enum ProductSort { none, priceLowToHigh, priceHighToLow, topRated }

// class HomeState extends Equatable {
//   final List<BranchModel> branches;
//   final BranchModel? selectedBranch;
//   final List<CategoryModel> categories;
//   final String selectedCategoryId;
//   final List<ProductModel> products;
//   final bool loading;
//   final String searchQuery;
//   final String? errorMessage;
//   final bool isLocationLoading;

//   // 1. إضافة حقل نوع الترتيب (الفلترة)
//   final ProductSort sortType;

//   const HomeState({
//     this.branches = const [],
//     this.selectedBranch,
//     this.categories = const [],
//     this.selectedCategoryId = 'all',
//     this.products = const [],
//     this.loading = false,
//     this.searchQuery = '',
//     this.errorMessage,
//     this.isLocationLoading = false,
//     // 2. القيمة الافتراضية هي 'none' أي بدون ترتيب محدد
//     this.sortType = ProductSort.none,
//   });

//   HomeState copyWith({
//     List<BranchModel>? branches,
//     BranchModel? selectedBranch,
//     List<CategoryModel>? categories,
//     String? selectedCategoryId,
//     List<ProductModel>? products,
//     bool? loading,
//     String? searchQuery,
//     String? errorMessage,
//     bool? isLocationLoading,
//     // 3. إضافة الحقل هنا ليتم تحديثه عند الفلترة
//     ProductSort? sortType,
//   }) {
//     return HomeState(
//       branches: branches ?? this.branches,
//       selectedBranch: selectedBranch ?? this.selectedBranch,
//       categories: categories ?? this.categories,
//       selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
//       products: products ?? this.products,
//       loading: loading ?? this.loading,
//       searchQuery: searchQuery ?? this.searchQuery,
//       errorMessage: errorMessage ?? this.errorMessage,
//       isLocationLoading: isLocationLoading ?? this.isLocationLoading,
//       // تمرير القيمة الجديدة أو الحفاظ على القديمة
//       sortType: sortType ?? this.sortType,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     branches,
//     selectedBranch,
//     categories,
//     selectedCategoryId,
//     products,
//     loading,
//     searchQuery,
//     errorMessage,
//     isLocationLoading,
//     // 4. ضروري جداً إضافة sortType هنا ليعرف Bloc أن الحالة تغيرت عند تغيير الفلتر
//     sortType,
//   ];
// }
