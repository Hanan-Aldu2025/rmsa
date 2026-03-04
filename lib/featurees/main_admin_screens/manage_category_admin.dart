// // categories_manager_cubit.dart
// import 'package:appp/core/widget/custom_build_AppBarr.dart';
// import 'package:appp/featurees/main_admin_screens/add_category.dart';
// import 'package:appp/featurees/main_screens/home/data/models/category_model.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CategoriesManagerCubit extends Cubit<CategoriesManagerState> {
//   CategoriesManagerCubit() : super(CategoriesManagerInitial());

//   // جلب الأقسام بشكل حي (Stream)
//   void getCategories() {
//     emit(CategoriesManagerLoading());
//     FirebaseFirestore.instance
//         .collection('categories')
//         .snapshots()
//         .listen(
//           (snapshot) {
//             List<CategoryModel> categories = snapshot.docs
//                 .map((doc) => CategoryModel.fromDoc(doc))
//                 .toList();
//             emit(CategoriesManagerSuccess(categories: categories));
//           },
//           onError: (e) {
//             emit(CategoriesManagerFailure(errMessage: e.toString()));
//           },
//         );
//   }

//   // حذف قسم
//   Future<void> deleteCategory(String id) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(id)
//           .delete();
//     } catch (e) {
//       emit(CategoriesManagerFailure(errMessage: "فشل الحذف: ${e.toString()}"));
//     }
//   }
// }

// class CategoriesManagerView extends StatelessWidget {
//   const CategoriesManagerView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CategoriesManagerCubit()..getCategories(),
//       child: Scaffold(
//         appBar: buildAppBar(context, title: "إدارة الأقسام"),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: AppColors.primaryColor,
//           onPressed: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddCategoryView()),
//           ),
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//         body: BlocBuilder<CategoriesManagerCubit, CategoriesManagerState>(
//           builder: (context, state) {
//             if (state is CategoriesManagerLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is CategoriesManagerSuccess) {
//               return ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: state.categories.length,
//                 itemBuilder: (context, index) {
//                   final category = state.categories[index];
//                   return _buildCategoryCard(context, category);
//                 },
//               );
//             } else if (state is CategoriesManagerFailure) {
//               return Center(child: Text(state.errMessage));
//             }
//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(12),
//         title: Text(
//           "${category.name} | ${category.nameAr}",
//           style: AppStyles.InriaSerif_14.copyWith(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 5),
//             Text(
//               "الفروع: ${category.branchIds.join(', ')}",
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // زر الحذف مع تأكيد
//             IconButton(
//               icon: const Icon(Icons.delete_outline, color: Colors.red),
//               onPressed: () => _showDeleteDialog(context, category),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteDialog(BuildContext context, CategoryModel category) {
//     showDialog(
//       context: context,
//       builder: (diagContext) => AlertDialog(
//         title: const Text("حذف القسم"),
//         content: Text("هل أنت متأكد من حذف قسم (${category.nameAr})؟"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(diagContext),
//             child: const Text("إلغاء"),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<CategoriesManagerCubit>().deleteCategory(
//                 category.id,
//               );
//               Navigator.pop(diagContext);
//             },
//             child: const Text("حذف", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// abstract class CategoriesManagerState {}

// class CategoriesManagerInitial extends CategoriesManagerState {}

// class CategoriesManagerLoading extends CategoriesManagerState {}

// class CategoriesManagerSuccess extends CategoriesManagerState {
//   final List<CategoryModel> categories;
//   CategoriesManagerSuccess({required this.categories});
// }

// class CategoriesManagerFailure extends CategoriesManagerState {
//   final String errMessage;
//   CategoriesManagerFailure({required this.errMessage});
// }
