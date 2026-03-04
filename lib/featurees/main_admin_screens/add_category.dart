// // add_category_cubit.dart
// import 'package:appp/core/widget/custom_build_AppBarr.dart';
// import 'package:appp/core/widget/custom_button.dart';
// import 'package:appp/featurees/main_screens/personal/presentation/pages/personal_view.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// class AddCategoryCubit extends Cubit<AddCategoryState> {
//   AddCategoryCubit() : super(AddCategoryInitial());

//   // قائمة الفروع الثابتة كما طلبتِ
//   final List<Map<String, String>> availableBranches = [
//     {'id': 'main_branch', 'name': 'Main Branch'},
//     {'id': 'city_center_branch', 'name': 'City Center Branch'},
//     {'id': 'Industrial_city_branch', 'name': 'Industrial City Branch'},
//   ];

//   List<String> selectedBranches = [];

//   void toggleBranch(String branchId) {
//     if (selectedBranches.contains(branchId)) {
//       selectedBranches.remove(branchId);
//     } else {
//       selectedBranches.add(branchId);
//     }
//     emit(AddCategoryInitial()); // لإعادة بناء الواجهة وتحديث شكل الاختيار
//   }

//   Future<void> addCategory({
//     required String nameEn,
//     required String nameAr,
//   }) async {
//     if (nameEn.isEmpty || nameAr.isEmpty || selectedBranches.isEmpty) {
//       emit(
//         AddCategoryFailure(
//           errMessage: "الرجاء ملء جميع الحقول واختيار فرع واحد على الأقل",
//         ),
//       );
//       return;
//     }

//     emit(AddCategoryLoading());
//     try {
//       await FirebaseFirestore.instance.collection('categories').add({
//         'name': nameEn,
//         'name_ar': nameAr,
//         'branchIds': selectedBranches,
//       });
//       emit(AddCategorySuccess());
//       selectedBranches.clear();
//     } catch (e) {
//       emit(AddCategoryFailure(errMessage: e.toString()));
//     }
//   }
// }

// class AddCategoryView extends StatefulWidget {
//   const AddCategoryView({super.key});

//   @override
//   State<AddCategoryView> createState() => _AddCategoryViewState();
// }

// class _AddCategoryViewState extends State<AddCategoryView> {
//   final TextEditingController nameEnController = TextEditingController();
//   final TextEditingController nameArController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AddCategoryCubit(),
//       child: BlocConsumer<AddCategoryCubit, AddCategoryState>(
//         listener: (context, state) {
//           if (state is AddCategorySuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("تمت إضافة القسم بنجاح")),
//             );
//             nameEnController.clear();
//             nameArController.clear();
//           }
//         },
//         builder: (context, state) {
//           final cubit = context.read<AddCategoryCubit>();

//           return Scaffold(
//             appBar: buildAppBar(context, title: "إضافة قسم جديد"),
//             body: ModalProgressHUD(
//               inAsyncCall: state is AddCategoryLoading,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomTextField(
//                       controller: nameEnController,
//                       label: "اسم القسم (English)",
//                       icon: Icons.language,
//                     ),
//                     const SizedBox(height: 15),
//                     CustomTextField(
//                       controller: nameArController,
//                       label: "اسم القسم (عربي)",
//                       icon: Icons.text_fields,
//                     ),
//                     const SizedBox(height: 25),
//                     const Text(
//                       "اختر الفروع التابعة لها:",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),

//                     // عرض الفروع كقائمة اختيار متعدد
//                     ...cubit.availableBranches.map((branch) {
//                       final isSelected = cubit.selectedBranches.contains(
//                         branch['id'],
//                       );
//                       return CheckboxListTile(
//                         title: Text(branch['name']!),
//                         value: isSelected,
//                         activeColor: AppColors.primaryColor,
//                         onChanged: (val) => cubit.toggleBranch(branch['id']!),
//                       );
//                     }).toList(),

//                     const SizedBox(height: 30),
//                     CustomButton(
//                       text: "إضافة القسم",
//                       onpressed: () {
//                         cubit.addCategory(
//                           nameEn: nameEnController.text,
//                           nameAr: nameArController.text,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// abstract class AddCategoryState {}

// class AddCategoryInitial extends AddCategoryState {}

// class AddCategoryLoading extends AddCategoryState {}

// class AddCategorySuccess extends AddCategoryState {}

// class AddCategoryFailure extends AddCategoryState {
//   final String errMessage;
//   AddCategoryFailure({required this.errMessage});
// }
