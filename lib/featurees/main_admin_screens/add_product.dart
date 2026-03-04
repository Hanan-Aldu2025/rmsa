import 'dart:convert';
import 'dart:io';

import 'package:appp/featurees/main_screens/home/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// تأكدي من استيراد الموديلات الخاصة بك هنا
// import 'package:your_app/models/product_model.dart';

// ==========================================
// 1. Add Product Cubit (إدارة الحالة والرفع)
// ==========================================
class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  final String imgBBKey = "7b2be8682e2f557719ba5e1c0666352a";

  List<ProductSize> sizes = [];
  String? selectedCategoryId;
  List<String> selectedBranches = [];

  void addSize(ProductSize size) {
    sizes.add(size);
    emit(AddProductInitial());
  }

  void removeSize(int index) {
    sizes.removeAt(index);
    emit(AddProductInitial());
  }

  void toggleBranch(String branchId) {
    if (selectedBranches.contains(branchId)) {
      selectedBranches.remove(branchId);
    } else {
      selectedBranches.add(branchId);
    }
    emit(AddProductInitial());
  }

  Future<String?> uploadImageToImgBB(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$imgBBKey'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        var resData = await http.Response.fromStream(response);
        var jsonRes = jsonDecode(resData.body);
        return jsonRes['data']['url'];
      }
    } catch (e) {
      debugPrint("ImgBB Error: $e");
    }
    return null;
  }

  Future<void> saveProduct({
    required Map<String, dynamic> data,
    required File? imageFile,
  }) async {
    if (imageFile == null) {
      emit(AddProductFailure("يرجى اختيار صورة أولاً"));
      return;
    }
    if (selectedCategoryId == null) {
      emit(AddProductFailure("يرجى اختيار القسم"));
      return;
    }
    if (selectedBranches.isEmpty) {
      emit(AddProductFailure("يرجى اختيار فرع واحد على الأقل"));
      return;
    }

    emit(AddProductLoading());

    String? imageUrl = await uploadImageToImgBB(imageFile);
    if (imageUrl == null) {
      emit(AddProductFailure("فشل رفع الصورة لموقع ImgBB"));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('products').add({
        ...data,
        'imageUrl': imageUrl,
        'categoryId': selectedCategoryId,
        'branchIds': selectedBranches, // الربط مع الفروع
        'sizes': sizes
            .map(
              (s) => {
                'lable': s.label,
                'size': s.size,
                'size_oz': s.sizeOz,
                'price': s.price,
              },
            )
            .toList(),
        'extraoption':
            [], // يمكنك إضافة منطق الإضافات هنا لاحقاً بنفس طريقة الأحجام
        'isAvaliable': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductFailure("خطأ في قاعدة البيانات: ${e.toString()}"));
    }
  }
}

// ==========================================
// 2. Add Product View (الواجهة)
// ==========================================
class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  File? _image;
  final _formKey = GlobalKey<FormState>();

  final nameEn = TextEditingController();
  final nameAr = TextEditingController();
  final price = TextEditingController();
  final descEn = TextEditingController();
  final descAr = TextEditingController();
  final points = TextEditingController();
  final discount = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة منتج للفروع"),
          centerTitle: true,
        ),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم الحفظ والربط بالفروع بنجاح!")),
              );
              Navigator.pop(context);
            }
            if (state is AddProductFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            var cubit = context.read<AddProductCubit>();
            return ModalProgressHUD(
              inAsyncCall: state is AddProductLoading,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 20),

                    _buildSectionTitle("البيانات الأساسية"),
                    _customField(nameEn, "الاسم بالإنجليزية"),
                    _customField(nameAr, "الاسم بالعربية"),
                    _customField(price, "السعر الأساسي", isNumber: true),
                    _customField(descEn, "الوصف بالإنجليزية", maxLines: 2),
                    _customField(descAr, "الوصف بالعربية", maxLines: 2),

                    Row(
                      children: [
                        Expanded(
                          child: _customField(points, "النقاط", isNumber: true),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _customField(
                            discount,
                            "الخصم",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    _buildCategoryDropdown(cubit),

                    const SizedBox(height: 20),
                    // --- إضافة قسم اختيار الفروع ---
                    _buildBranchSelection(cubit),

                    const SizedBox(height: 25),
                    _buildSizesSection(cubit),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.saveProduct(
                            imageFile: _image,
                            data: {
                              'name': nameEn.text,
                              'name_ar': nameAr.text,
                              'price': double.tryParse(price.text) ?? 0,
                              'description': descEn.text,
                              'description_ar': descAr.text,
                              'points': int.tryParse(points.text) ?? 0,
                              'discount': double.tryParse(discount.text) ?? 0,
                            },
                          );
                        }
                      },
                      child: const Text(
                        "حفظ المنتج النهائي",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- مكونات الواجهة ---

  Widget _buildBranchSelection(AddProductCubit cubit) {
    final List<Map<String, String>> branches = [
      {'id': 'main_branch', 'name': 'Main Branch'},
      {'id': 'city_center_branch', 'name': 'City Center Branch'},
      {'id': 'Industrial_city_branch', 'name': 'Industrial City Branch'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("الفروع المتاح فيها (مهم للظهور)"),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: branches.map((branch) {
              return CheckboxListTile(
                title: Text(branch['name']!),
                value: cubit.selectedBranches.contains(branch['id']),
                onChanged: (val) => cubit.toggleBranch(branch['id']!),
                activeColor: Colors.brown,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_image!, fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  Text("اضغط لإضافة صورة"),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget _customField(
    TextEditingController ctrl,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        validator: (v) => v!.isEmpty ? "مطلوب" : null,
      ),
    );
  }

  Widget _buildCategoryDropdown(AddProductCubit cubit) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "اختر القسم",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: snapshot.data!.docs
              .map(
                (doc) => DropdownMenuItem(
                  value: doc.id,
                  child: Text(doc['name_ar'] ?? doc['name']),
                ),
              )
              .toList(),
          onChanged: (val) => cubit.selectedCategoryId = val,
          validator: (v) => v == null ? "يرجى اختيار قسم" : null,
        );
      },
    );
  }

  Widget _buildSizesSection(AddProductCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "الأحجام (اختياري)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => _showSizeDialog(cubit),
              icon: const Icon(Icons.add_box, color: Colors.brown),
            ),
          ],
        ),
        if (cubit.sizes.isEmpty)
          const Text(
            "لا توجد أحجام (سيظهر السعر الأساسي فقط)",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        Wrap(
          spacing: 8,
          children: cubit.sizes
              .asMap()
              .entries
              .map(
                (entry) => Chip(
                  label: Text("${entry.value.label} (${entry.value.price}\$)"),
                  onDeleted: () => cubit.removeSize(entry.key),
                  deleteIconColor: Colors.red,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _showSizeDialog(AddProductCubit cubit) {
    final l = TextEditingController(),
        p = TextEditingController(),
        s = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("أضف حجماً"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: l,
              decoration: const InputDecoration(labelText: "اسم الحجم (كبير)"),
            ),
            TextField(
              controller: s,
              decoration: const InputDecoration(labelText: "الرمز (L)"),
            ),
            TextField(
              controller: p,
              decoration: const InputDecoration(labelText: "السعر لهذا الحجم"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              if (l.text.isNotEmpty && p.text.isNotEmpty) {
                cubit.addSize(
                  ProductSize(
                    label: l.text,
                    size: s.text,
                    price: double.parse(p.text),
                  ),
                );
                Navigator.pop(c);
              }
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. States
// ==========================================
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductFailure extends AddProductState {
  final String errMessage;
  AddProductFailure(this.errMessage);
}

// abstract class AddProductState {}

// class AddProductInitial extends AddProductState {}

// class AddProductLoading extends AddProductState {}

// class AddProductSuccess extends AddProductState {}

// class AddProductFailure extends AddProductState {
//   final String errMessage;
//   AddProductFailure(this.errMessage);
// }

// قم بتغيير الاستيرادات حسب مسارات مشروعك
// import 'package:your_project/models/product_model.dart';
// import 'package:your_project/core/utils/app_colors.dart';
// import 'package:your_project/core/utils/app_styles.dart';

// ==========================================
// 1. Add Product Cubit
// ==========================================

// class AddProductCubit extends Cubit<AddProductState> {
//   AddProductCubit() : super(AddProductInitial());

//   final String imgBBKey = "7b2be8682e2f557719ba5e1c0666352a";

//   List<ProductSize> sizes = [];
//   List<ExtraOptionModel> extraOptions = [];
//   String? selectedCategoryId;
//   List<String> selectedBranches = [];

//   void addSize(ProductSize size) {
//     sizes.add(size);
//     emit(AddProductInitial());
//   }

//   void removeSize(int index) {
//     sizes.removeAt(index);
//     emit(AddProductInitial());
//   }

//   void toggleBranch(String branchId) {
//     selectedBranches.contains(branchId)
//         ? selectedBranches.remove(branchId)
//         : selectedBranches.add(branchId);
//     emit(AddProductInitial());
//   }

//   Future<String?> uploadImageToImgBB(File imageFile) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('https://api.imgbb.com/1/upload?key=$imgBBKey'),
//       );
//       request.files.add(
//         await http.MultipartFile.fromPath('image', imageFile.path),
//       );

//       var response = await request.send();
//       if (response.statusCode == 200) {
//         var resData = await http.Response.fromStream(response);
//         var jsonRes = jsonDecode(resData.body);
//         return jsonRes['data']['url'];
//       }
//     } catch (e) {
//       debugPrint("ImgBB Error: $e");
//     }
//     return null;
//   }

//   Future<void> saveProduct({
//     required Map<String, dynamic> data,
//     required File? imageFile,
//   }) async {
//     if (imageFile == null) {
//       emit(AddProductFailure("يرجى اختيار صورة أولاً"));
//       return;
//     }
//     if (selectedCategoryId == null) {
//       emit(AddProductFailure("يرجى اختيار القسم"));
//       return;
//     }

//     emit(AddProductLoading());

//     // 1. رفع الصورة
//     String? imageUrl = await uploadImageToImgBB(imageFile);
//     if (imageUrl == null) {
//       emit(AddProductFailure("فشل رفع الصورة لموقع ImgBB"));
//       return;
//     }

//     try {
//       // 2. الحفظ في Firestore
//       await FirebaseFirestore.instance.collection('products').add({
//         ...data,
//         'imageUrl': imageUrl,
//         'categoryId': selectedCategoryId,
//         'branchIds': selectedBranches,
//         'sizes': sizes
//             .map(
//               (s) => {
//                 'lable': s.label,
//                 'size': s.size,
//                 'size_oz': s.sizeOz,
//                 'price': s.price,
//               },
//             )
//             .toList(),
//         'extraoption': extraOptions
//             .map((e) => {'option': e.option, 'optionprice': e.price})
//             .toList(),
//         'isAvaliable': true,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       emit(AddProductSuccess());
//     } catch (e) {
//       emit(AddProductFailure(e.toString()));
//     }
//   }
// }

// ==========================================
// 2. Add Product View
// // ==========================================
// class AddProductView extends StatefulWidget {
//   const AddProductView({super.key});

//   @override
//   State<AddProductView> createState() => _AddProductViewState();
// }

// class _AddProductViewState extends State<AddProductView> {
//   File? _image;
//   final _formKey = GlobalKey<FormState>();

//   final nameEn = TextEditingController();
//   final nameAr = TextEditingController();
//   final price = TextEditingController();
//   final descEn = TextEditingController();
//   final descAr = TextEditingController();
//   final points = TextEditingController();
//   final discount = TextEditingController();

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) setState(() => _image = File(pickedFile.path));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AddProductCubit(),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("إضافة منتج جديد"), centerTitle: true),
//         body: BlocConsumer<AddProductCubit, AddProductState>(
//           listener: (context, state) {
//             if (state is AddProductSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("تم إضافة المنتج بنجاح")),
//               );
//               Navigator.pop(context);
//             }
//             if (state is AddProductFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             var cubit = context.read<AddProductCubit>();
//             return ModalProgressHUD(
//               inAsyncCall: state is AddProductLoading,
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     // --- رفع الصورة ---
//                     _buildImagePicker(),
//                     const SizedBox(height: 20),

//                     // --- البيانات الأساسية ---
//                     _buildSectionTitle("البيانات الأساسية"),
//                     _customField(nameEn, "الاسم بالإنجليزية"),
//                     _customField(nameAr, "الاسم بالعربية"),
//                     _customField(price, "السعر الأساسي", isNumber: true),
//                     _customField(descEn, "الوصف بالإنجليزية", maxLines: 2),
//                     _customField(descAr, "الوصف بالعربية", maxLines: 2),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: _customField(points, "النقاط", isNumber: true),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _customField(
//                             discount,
//                             "الخصم",
//                             isNumber: true,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 15),
//                     _buildCategoryDropdown(cubit),

//                     const SizedBox(height: 25),
//                     // --- قسم الأحجام ---
//                     _buildSizesSection(cubit),

//                     const SizedBox(height: 40),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             Colors.brown, // غيريه لـ AppColors.primary
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () => _submit(cubit),
//                       child: const Text(
//                         "حفظ المنتج",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _submit(AddProductCubit cubit) {
//     if (_formKey.currentState!.validate()) {
//       cubit.saveProduct(
//         imageFile: _image,
//         data: {
//           'name': nameEn.text,
//           'name_ar': nameAr.text,
//           'price': double.tryParse(price.text) ?? 0,
//           'description': descEn.text,
//           'description_ar': descAr.text,
//           'points': int.tryParse(points.text) ?? 0,
//           'discount': double.tryParse(discount.text) ?? 0,
//         },
//       );
//     }
//   }

//   // --- ويدجت فرعية للمساعدة ---

//   Widget _buildImagePicker() {
//     return GestureDetector(
//       onTap: _pickImage,
//       child: Container(
//         height: 160,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[400]!),
//         ),
//         child: _image != null
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.file(_image!, fit: BoxFit.cover),
//               )
//             : const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.camera_alt, size: 40, color: Colors.grey),
//                   Text("اضغط لإضافة صورة"),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10, top: 10),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//           color: Colors.brown,
//         ),
//       ),
//     );
//   }

//   Widget _customField(
//     TextEditingController ctrl,
//     String label, {
//     bool isNumber = false,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: ctrl,
//         maxLines: maxLines,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 10,
//           ),
//         ),
//         validator: (v) => v!.isEmpty ? "مطلوب" : null,
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown(AddProductCubit cubit) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const LinearProgressIndicator();
//         return DropdownButtonFormField<String>(
//           decoration: InputDecoration(
//             labelText: "اختر القسم",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           items: snapshot.data!.docs
//               .map(
//                 (doc) => DropdownMenuItem(
//                   value: doc.id,
//                   child: Text(doc['name_ar'] ?? doc['name']),
//                 ),
//               )
//               .toList(),
//           onChanged: (val) => cubit.selectedCategoryId = val,
//           validator: (v) => v == null ? "يرجى اختيار قسم" : null,
//         );
//       },
//     );
//   }

//   Widget _buildSizesSection(AddProductCubit cubit) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "الأحجام (اختياري)",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//               onPressed: () => _showSizeDialog(cubit),
//               icon: const Icon(Icons.add_box, color: Colors.brown),
//             ),
//           ],
//         ),
//         Wrap(
//           spacing: 8,
//           children: cubit.sizes
//               .asMap()
//               .entries
//               .map(
//                 (entry) => Chip(
//                   label: Text("${entry.value.label} (${entry.value.price}\$)"),
//                   onDeleted: () => cubit.removeSize(entry.key),
//                   deleteIconColor: Colors.red,
//                 ),
//               )
//               .toList(),
//         ),
//       ],
//     );
//   }

//   void _showSizeDialog(AddProductCubit cubit) {
//     final l = TextEditingController(),
//         p = TextEditingController(),
//         s = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (c) => AlertDialog(
//         title: const Text("أضف حجماً"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: l,
//               decoration: const InputDecoration(labelText: "اسم الحجم (كبير)"),
//             ),
//             TextField(
//               controller: s,
//               decoration: const InputDecoration(labelText: "الرمز (L)"),
//             ),
//             TextField(
//               controller: p,
//               decoration: const InputDecoration(labelText: "السعر"),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(c),
//             child: const Text("إلغاء"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               cubit.addSize(
//                 ProductSize(
//                   label: l.text,
//                   size: s.text,
//                   price: double.parse(p.text),
//                 ),
//               );
//               Navigator.pop(c);
//             },
//             child: const Text("إضافة"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddProductCubit extends Cubit<AddProductState> {
//   AddProductCubit() : super(AddProductInitial());

//   // قوائم البيانات الديناميكية
//   List<ProductSize> sizes = [];
//   List<ExtraOptionModel> extraOptions = [];
//   List<String> selectedBranches = [];
//   String? selectedCategoryId;

//   // لإضافة حجم جديد للقائمة المؤقتة
//   void addSize(ProductSize size) {
//     sizes.add(size);
//     emit(AddProductInitial()); 
//   }

//   // لإضافة خيار إضافي جديد
//   void addExtra(ExtraOptionModel extra) {
//     extraOptions.add(extra);
//     emit(AddProductInitial());
//   }

//   void toggleBranch(String branchId) {
//     selectedBranches.contains(branchId) ? selectedBranches.remove(branchId) : selectedBranches.add(branchId);
//     emit(AddProductInitial());
//   }

//   Future<void> uploadProduct(Map<String, dynamic> productData) async {
//     emit(AddProductLoading());
//     try {
//       await FirebaseFirestore.instance.collection('products').add({
//         ...productData,
//         'sizes': sizes.map((s) => {'lable': s.label, 'size': s.size, 'size_oz': s.sizeOz, 'price': s.price}).toList(),
//         'extraoption': extraOptions.map((e) => {'option': e.option, 'optionprice': e.price}).toList(),
//         'branchIds': selectedBranches,
//         'categoryId': selectedCategoryId,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       emit(AddProductSuccess());
//       sizes.clear();
//       extraOptions.clear();
//     } catch (e) {
//       emit(AddProductFailure(e.toString()));
//     }
//   }
// }
// class AddProductView extends StatefulWidget {
//   const AddProductView({super.key});

//   @override
//   State<AddProductView> createState() => _AddProductViewState();
// }

// class _AddProductViewState extends State<AddProductView> {
//   final _formKey = GlobalKey<FormState>();
//   // المتحكمات الأساسية
//   final nameController = TextEditingController();
//   final nameArController = TextEditingController();
//   final priceController = TextEditingController();
//   final descController = TextEditingController();
//   final descArController = TextEditingController();
//   final imageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AddProductCubit(),
//       child: Scaffold(
//         appBar: buildAppBar(context, title: "إضافة منتج جديد"),
//         body: BlocConsumer<AddProductCubit, AddProductState>(
//           listener: (context, state) {
//             if (state is AddProductSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إضافة المنتج بنجاح")));
//               Navigator.pop(context);
//             }
//           },
//           builder: (context, state) {
//             final cubit = context.read<AddProductCubit>();
//             return ModalProgressHUD(
//               inAsyncCall: state is AddProductLoading,
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     // 1. البيانات الأساسية
//                     _buildSectionTitle("البيانات الأساسية"),
//                     CustomTextField(controller: nameController, label: "اسم المنتج (EN)"),
//                     CustomTextField(controller: nameArController, label: "اسم المنتج (AR)"),
//                     CustomTextField(controller: priceController, label: "السعر الافتراضي", keyboardType: TextInputType.number),
//                     CustomTextField(controller: imageController, label: "رابط الصورة"),
                    
//                     const SizedBox(height: 20),
//                     // 2. اختيار القسم (Category)
//                     _buildCategoryDropdown(cubit),

//                     const SizedBox(height: 20),
//                     // 3. إضافة الأحجام (Sizes)
//                     _buildSectionTitle("الأحجام المتاحة"),
//                     _buildSizeInput(cubit),
//                     _buildSizesList(cubit),

//                     const SizedBox(height: 20),
//                     // 4. الخيارات الإضافية (Extras)
//                     _buildSectionTitle("إضافات اختيارية"),
//                     _buildExtraInput(cubit),
//                     _buildExtrasList(cubit),

//                     const SizedBox(height: 30),
//                     CustomButton(
//                       text: "حفظ المنتج النهائي",
//                       onpressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           cubit.uploadProduct({
//                             'name': nameController.text,
//                             'name_ar': nameArController.text,
//                             'price': double.tryParse(priceController.text) ?? 0,
//                             'imageUrl': imageController.text,
//                             'description': descController.text,
//                             'description_ar': descArController.text,
//                             'isAvaliable': true,
//                           });
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // دالة لبناء عنوان القسم
//   Widget _buildSectionTitle(String title) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Text(title, style: AppStyles.titleLora18.copyWith(fontSize: 16, color: AppColors.primaryColor)),
//   );

//   // دالة لإدخال الأحجام بشكل سريع
//   Widget _buildSizeInput(AddProductCubit cubit) {
//     return Row(
//       children: [
//         Expanded(child: TextField(decoration: const InputDecoration(hintText: "Label (Small)"), onSubmitted: (val) {})),
//         const SizedBox(width: 5),
//         Expanded(child: TextField(decoration: const InputDecoration(hintText: "Price"), keyboardType: TextInputType.number)),
//         IconButton(
//           icon: const Icon(Icons.add_circle, color: Colors.green),
//           onPressed: () {
//             // هنا يتم أخذ القيم وإضافتها للـ Cubit
//             cubit.addSize(ProductSize(label: "Small", size: "s", price: 15, sizeOz: 5));
//           },
//         )
//       ],
//     );
//   }

//   Widget _buildSizesList(AddProductCubit cubit) {
//     return Wrap(
//       children: cubit.sizes.map((s) => Chip(label: Text("${s.label}: ${s.price}\$"))).toList(),
//     );
//   }

//   // دالة جلب الأقسام من فيربيز لاختيار واحد منها
//   Widget _buildCategoryDropdown(AddProductCubit cubit) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const LinearProgressIndicator();
//         var items = snapshot.data!.docs;
//         return DropdownButtonFormField<String>(
//           decoration: const InputDecoration(labelText: "اختر القسم"),
//           items: items.map((doc) => DropdownMenuItem(
//             value: doc.id,
//             child: Text(doc['name_ar']),
//           )).toList(),
//           onChanged: (val) => cubit.selectedCategoryId = val,
//         );
//       },
//     );
//   }
  
//   // دالة بناء قائمة الإضافات (مختصرة)
//   Widget _buildExtraInput(AddProductCubit cubit) { /* مماثلة لدالة الحجم */ return const SizedBox(); }
//   Widget _buildExtrasList(AddProductCubit cubit) { /* مماثلة لدالة عرض الحجم */ return const SizedBox(); }
// }