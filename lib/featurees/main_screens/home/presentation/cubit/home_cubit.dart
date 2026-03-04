import 'dart:async';
import 'package:appp/featurees/main_screens/home/data/models/branch_model.dart';
import 'package:appp/featurees/main_screens/home/data/models/product_model.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

// class HomeCubit extends Cubit<HomeState> {
//   final HomeRepos repository;

//   // دالة لحفظ ID الفرع في الذاكرة
//   Future<void> _saveSelectedBranch(String branchId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('last_branch_id', branchId);
//   }

//   // دالة لجلب ID الفرع المحفوظ
//   Future<String?> _getLastSavedBranch() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('last_branch_id');
//   }

//   Future<void> loadInitialData() async {
//     emit(state.copyWith(loading: true));
//     final branches = await repository.fetchBranches();

//     if (branches.isEmpty) {
//       emit(state.copyWith(loading: false));
//       return;
//     }

//     final prefs = await SharedPreferences.getInstance();
//     final savedBranchId = prefs.getString('last_branch_id');

//     BranchModel? selected;

//     if (savedBranchId != null) {
//       selected = branches.firstWhere(
//         (b) => b.id == savedBranchId,
//         orElse: () => branches.first,
//       );
//     } else {
//       emit(state.copyWith(isLocationLoading: true));
//       selected = await _findNearestBranch(branches);
//       emit(state.copyWith(isLocationLoading: false));

//       if (selected != null) {
//         await prefs.setString('last_branch_id', selected.id);
//       }
//     }

//     // 🔥 الجزء الناقص: جلب الأقسام للفرع الذي تم اختياره
//     final categories = await repository.fetchCategoriesForBranch(selected!.id);

//     emit(
//       state.copyWith(
//         branches: branches,
//         selectedBranch: selected,
//         categories: categories, // ✅ إرسال الأقسام للحالة
//         loading: false,
//       ),
//     );
//     _listenProducts();
//   }

//   // دالة حساب أقرب فرع
//   Future<BranchModel> _findNearestBranch(List<BranchModel> branches) async {
//     try {
//       // طلب الإذن والموقع
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         Position position = await Geolocator.getCurrentPosition();

//         BranchModel nearest = branches.first;
//         double minDistance = double.maxFinite;

//         for (var branch in branches) {
//           double distance = Geolocator.distanceBetween(
//             position.latitude,
//             position.longitude,
//             branch.lat,
//             branch.lng,
//           );
//           if (distance < minDistance) {
//             minDistance = distance;
//             nearest = branch;
//           }
//         }
//         return nearest;
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//     return branches.first; // افتراضي إذا فشل جلب الموقع
//   }

//   // تعديل دالة اختيار الفرع يدوياً لحفظها
//   void selectBranch(BranchModel branch) async {
//     emit(
//       state.copyWith(loading: true),
//     ); // إظهار تحميل بسيط أثناء جلب الأقسام الجديدة

//     // جلب أقسام الفرع الجديد
//     final categories = await repository.fetchCategoriesForBranch(branch.id);

//     emit(
//       state.copyWith(
//         selectedBranch: branch,
//         categories: categories, // ✅ تحديث الأقسام في الواجهة
//         selectedCategoryId: 'all',
//         loading: false,
//       ),
//     );

//     await _saveSelectedBranch(branch.id);
//     _listenProducts();
//   }

//   StreamSubscription? _productsSub;
//   final TextEditingController searchController = TextEditingController();
//   HomeCubit({required this.repository}) : super(const HomeState());

//   @override
//   Future<void> close() {
//     searchController.dispose();
//     _productsSub?.cancel();
//     return super.close();
//   }

//   // تم تحسين هذه الدالة لتحديث الحالة فورياً عند أي تغيير في الفيربيس
//   void _listenProducts() {
//     _productsSub?.cancel();
//     _productsSub = repository
//         .watchProducts(
//           branchId: state.selectedBranch!.id,
//           categoryId: state.selectedCategoryId,
//         )
//         .listen(
//           (products) {
//             // هنا سيتم التحديث فوراً دون الحاجة لعمل ريستارت
//             emit(state.copyWith(products: products, loading: false));
//           },
//           onError: (error) {
//             emit(state.copyWith(errorMessage: error.toString()));
//           },
//         );
//   }

//   // عند اختيار قسم جديد، نتأكد من تصفير القائمة القديمة لإعطاء شعور بالسرعة
//   void selectCategory(String id) {
//     if (state.selectedCategoryId == id) return;
//     emit(state.copyWith(selectedCategoryId: id, products: []));
//     _listenProducts();
//   }

//   Future<void> search(String query) async {
//     // تحديث نص البحث في الحالة
//     emit(state.copyWith(searchQuery: query));

//     if (query.trim().isEmpty) {
//       _listenProducts(); // العودة للبث اللحظي إذا كان المربع فارغاً
//       return;
//     }

//     // إيقاف الاستماع اللحظي مؤقتاً أثناء البحث اليدوي
//     _productsSub?.cancel();

//     try {
//       final result = await repository.searchProducts(
//         branchId: state.selectedBranch!.id,
//         queryText: query,
//       );

//       // تحديث القائمة بالنتائج التي عثرنا عليها (عربي أو إنجليزي)
//       emit(state.copyWith(products: result, loading: false));
//     } catch (e) {
//       print("Search Error: $e");
//     }
//   }

//   void clearSearch() {
//     searchController.clear(); // مسح النص من الحقل
//     search(""); // استدعاء دالة البحث بنص فارغ لإعادة كل المنتجات
//   }

//   void sortProducts(ProductSort sort) {
//     emit(state.copyWith(sortType: sort));
//     List<ProductModel> sortedList = List.from(state.products);

//     switch (sort) {
//       case ProductSort.priceLowToHigh:
//         sortedList.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case ProductSort.priceHighToLow:
//         sortedList.sort((a, b) => b.price.compareTo(a.price));
//         break;
//       case ProductSort.topRated:
//         // إذا كان عندك حقل تقييم في المنتج
//         break;
//       default:
//         _listenProducts(); // إعادة القائمة للوضع الطبيعي
//         return;
//     }
//     emit(state.copyWith(products: sortedList));
//   }
// }

// class HomeCubit extends Cubit<HomeState> {
//   final HomeRepos repository;
//   StreamSubscription? _productsSub;
//   final TextEditingController searchController = TextEditingController();

//   HomeCubit({required this.repository}) : super(const HomeState());

//   // دالة لحفظ ID الفرع في الذاكرة
//   Future<void> _saveSelectedBranch(String branchId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('last_branch_id', branchId);
//   }

//   // دالة لجلب ID الفرع المحفوظ
//   Future<String?> _getLastSavedBranch() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('last_branch_id');
//   }

//   Future<void> loadInitialData() async {
//     if (isClosed) return; // حماية
//     emit(state.copyWith(loading: true));

//     final branches = await repository.fetchBranches();
//     if (isClosed) return; // حماية بعد الـ await

//     if (branches.isEmpty) {
//       emit(state.copyWith(loading: false));
//       return;
//     }

//     final prefs = await SharedPreferences.getInstance();
//     final savedBranchId = prefs.getString('last_branch_id');

//     BranchModel? selected;

//     if (savedBranchId != null) {
//       selected = branches.firstWhere(
//         (b) => b.id == savedBranchId,
//         orElse: () => branches.first,
//       );
//     } else {
//       if (!isClosed) emit(state.copyWith(isLocationLoading: true));
//       selected = await _findNearestBranch(branches);
//       if (isClosed) return;
//       emit(state.copyWith(isLocationLoading: false));

//       if (selected != null) {
//         await prefs.setString('last_branch_id', selected.id);
//       }
//     }

//     // جلب الأقسام للفرع الذي تم اختياره
//     final categories = await repository.fetchCategoriesForBranch(selected!.id);
//     if (isClosed) return;

//     emit(
//       state.copyWith(
//         branches: branches,
//         selectedBranch: selected,
//         categories: categories,
//         loading: false,
//       ),
//     );
//     _listenProducts();
//   }

//   // دالة حساب أقرب فرع
//   Future<BranchModel> _findNearestBranch(List<BranchModel> branches) async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         Position position = await Geolocator.getCurrentPosition();

//         BranchModel nearest = branches.first;
//         double minDistance = double.maxFinite;

//         for (var branch in branches) {
//           double distance = Geolocator.distanceBetween(
//             position.latitude,
//             position.longitude,
//             branch.lat,
//             branch.lng,
//           );
//           if (distance < minDistance) {
//             minDistance = distance;
//             nearest = branch;
//           }
//         }
//         return nearest;
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//     return branches.first;
//   }

//   void selectBranch(BranchModel branch) async {
//     if (isClosed) return;
//     emit(state.copyWith(loading: true));

//     final categories = await repository.fetchCategoriesForBranch(branch.id);
//     if (isClosed) return;

//     emit(
//       state.copyWith(
//         selectedBranch: branch,
//         categories: categories,
//         selectedCategoryId: 'all',
//         loading: false,
//       ),
//     );

//     await _saveSelectedBranch(branch.id);
//     _listenProducts();
//   }

//   @override
//   Future<void> close() {
//     searchController.dispose();
//     _productsSub?.cancel();
//     return super.close();
//   }

//   void _listenProducts() {
//     _productsSub?.cancel();
//     _productsSub = repository
//         .watchProducts(
//           branchId: state.selectedBranch!.id,
//           categoryId: state.selectedCategoryId,
//         )
//         .listen(
//           (products) {
//             if (!isClosed) {
//               emit(state.copyWith(products: products, loading: false));
//             }
//           },
//           onError: (error) {
//             if (!isClosed) {
//               emit(state.copyWith(errorMessage: error.toString()));
//             }
//           },
//         );
//   }

//   void selectCategory(String id) {
//     if (state.selectedCategoryId == id) return;
//     emit(state.copyWith(selectedCategoryId: id, products: []));
//     _listenProducts();
//   }

//   Future<void> search(String query) async {
//     if (isClosed) return;
//     emit(state.copyWith(searchQuery: query));

//     if (query.trim().isEmpty) {
//       _listenProducts();
//       return;
//     }

//     _productsSub?.cancel();

//     try {
//       final result = await repository.searchProducts(
//         branchId: state.selectedBranch!.id,
//         queryText: query,
//       );

//       if (!isClosed) {
//         emit(state.copyWith(products: result, loading: false));
//       }
//     } catch (e) {
//       print("Search Error: $e");
//     }
//   }

//   void clearSearch() {
//     searchController.clear();
//     search("");
//   }

//   void sortProducts(ProductSort sort) {
//     if (isClosed) return;
//     emit(state.copyWith(sortType: sort));
//     List<ProductModel> sortedList = List.from(state.products);

//     switch (sort) {
//       case ProductSort.priceLowToHigh:
//         sortedList.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case ProductSort.priceHighToLow:
//         sortedList.sort((a, b) => b.price.compareTo(a.price));
//         break;
//       case ProductSort.topRated:
//         break;
//       default:
//         _listenProducts();
//         return;
//     }
//     emit(state.copyWith(products: sortedList));
//   }
// }
