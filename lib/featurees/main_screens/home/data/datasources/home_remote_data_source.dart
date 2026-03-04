// // 📁 data/datasources/home_remote_data_source.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/branch_model.dart';
// import '../models/category_model.dart';
// import '../models/product_model.dart';

// class HomeRemoteDataSource {
//   final FirebaseFirestore firestore;

//   HomeRemoteDataSource({FirebaseFirestore? firestoreInstance})
//     : firestore = firestoreInstance ?? FirebaseFirestore.instance;

//   Future<List<BranchModel>> getBranches() async {
//     final snap = await firestore.collection('branches').get();
//     return snap.docs.map((d) => BranchModel.fromDoc(d)).toList();
//   }

//   Future<List<CategoryModel>> getCategories(String branchId) async {
//     final snap = await firestore
//         .collection('categories')
//         .where('branchIds', arrayContains: branchId)
//         .get();
//     return snap.docs.map((d) => CategoryModel.fromDoc(d)).toList();
//   }

//   /// 🔥 REALTIME PRODUCTS
//   ///
//   Stream<List<ProductModel>> watchProducts(
//     String branchId, {
//     String? categoryId,
//   }) {
//     Query query = firestore
//         .collection('products')
//         .where('branchIds', arrayContains: branchId)
//         .where('isAvaliable', isEqualTo: true);

//     if (categoryId != null && categoryId != 'all') {
//       query = query.where('categoryId', isEqualTo: categoryId);
//     }

//     return query.snapshots().map(
//       (snap) => snap.docs.map((d) => ProductModel.fromDoc(d)).toList(),
//     );
//   }

//   Future<List<ProductModel>> searchProducts(
//     String branchId,
//     String queryText,
//   ) async {
//     // جلب المنتجات المتاحة في هذا الفرع
//     final snap = await firestore
//         .collection('products')
//         .where('branchIds', arrayContains: branchId)
//         .where('isAvaliable', isEqualTo: true)
//         .get();

//     final all = snap.docs.map((d) => ProductModel.fromDoc(d)).toList();

//     final lowerQuery = queryText.toLowerCase();

//     return all.where((p) {
//       // البحث في الاسم الإنجليزي والاسم العربي
//       final matchEn = p.name.toLowerCase().contains(lowerQuery);
//       final matchAr = p.nameAr.toLowerCase().contains(lowerQuery);

//       return matchEn || matchAr; // إذا وجد تطابق في أي منهما يظهر المنتج
//     }).toList();
//   }
// }
