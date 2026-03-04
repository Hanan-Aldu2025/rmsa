// product_manager_cubit.dart
import 'dart:io';

import 'package:appp/featurees/main_admin_screens/add_product.dart';
import 'package:appp/featurees/main_screens/home/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// product_manager_state.dart

abstract class ProductManagerState {}

class ProductManagerInitial extends ProductManagerState {}

class ProductManagerLoading extends ProductManagerState {}

class ProductManagerSuccess extends ProductManagerState {
  final List<ProductModel> products;
  ProductManagerSuccess({required this.products});
}

class ProductManagerFailure extends ProductManagerState {
  final String errMessage;
  ProductManagerFailure(this.errMessage);
}

class ProductManagerCubit extends Cubit<ProductManagerState> {
  ProductManagerCubit() : super(ProductManagerInitial());

  // جلب المنتجات بشكل حي (Stream)
  void getProducts() {
    emit(ProductManagerLoading());
    FirebaseFirestore.instance.collection('products').snapshots().listen((
      snapshot,
    ) {
      List<ProductModel> products = snapshot.docs
          .map((doc) => ProductModel.fromDoc(doc))
          .toList();
      emit(ProductManagerSuccess(products: products));
    }, onError: (e) => emit(ProductManagerFailure(e.toString())));
  }

  // حذف المنتج
  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
    } catch (e) {
      emit(ProductManagerFailure("فشل الحذف: $e"));
    }
  }
}

class ProductsManagerView extends StatelessWidget {
  const ProductsManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductManagerCubit()..getProducts(),
      child: Scaffold(
        appBar: AppBar(title: const Text("إدارة المنتجات"), centerTitle: true),
        body: BlocBuilder<ProductManagerCubit, ProductManagerState>(
          builder: (context, state) {
            if (state is ProductManagerLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is ProductManagerSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.nameAr),
                      subtitle: Text("${product.price} ريال"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProductView(product: product),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, product),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("لا توجد منتجات"));
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("حذف منتج"),
        content: Text("هل أنت متأكد من حذف ${product.nameAr}؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductManagerCubit>().deleteProduct(product.id);
              Navigator.pop(c);
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class EditProductView extends StatefulWidget {
  final ProductModel product;
  const EditProductView({super.key, required this.product});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  late TextEditingController nameAr, nameEn, price, descAr, descEn;
  File? _newImage;

  @override
  void initState() {
    super.initState();
    nameAr = TextEditingController(text: widget.product.nameAr);
    nameEn = TextEditingController(text: widget.product.name);
    price = TextEditingController(text: widget.product.price.toString());
    descAr = TextEditingController(text: widget.product.descriptionAr);
    descEn = TextEditingController(text: widget.product.description);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(), // نستخدم نفس الكيوبيت للرفع
      child: Scaffold(
        appBar: AppBar(title: const Text("تعديل المنتج")),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("تم التحديث بنجاح")));
            }
          },
          builder: (context, state) {
            var cubit = context.read<AddProductCubit>();
            return ModalProgressHUD(
              inAsyncCall: state is AddProductLoading,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // عرض الصورة الحالية أو الجديدة
                  GestureDetector(
                    onTap: () async {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null)
                        setState(() => _newImage = File(picked.path));
                    },
                    child: _newImage != null
                        ? Image.file(_newImage!, height: 150)
                        : Image.network(widget.product.imageUrl, height: 150),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: nameAr,
                    decoration: const InputDecoration(
                      labelText: "الاسم بالعربي",
                    ),
                  ),
                  TextField(
                    controller: nameEn,
                    decoration: const InputDecoration(
                      labelText: "الاسم بالإنجليزي",
                    ),
                  ),
                  TextField(
                    controller: price,
                    decoration: const InputDecoration(labelText: "السعر"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String finalImageUrl = widget.product.imageUrl;

                      // إذا اختار المدير صورة جديدة، نرفعها لـ ImgBB أولاً
                      if (_newImage != null) {
                        String? url = await cubit.uploadImageToImgBB(
                          _newImage!,
                        );
                        if (url != null) finalImageUrl = url;
                      }

                      // تحديث البيانات في Firestore
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.product.id)
                          .update({
                            'name_ar': nameAr.text,
                            'name': nameEn.text,
                            'price': double.parse(price.text),
                            'description_ar': descAr.text,
                            'description': descEn.text,
                            'imageUrl': finalImageUrl,
                          });

                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text("تحديث البيانات"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
