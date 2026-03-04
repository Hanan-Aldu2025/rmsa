import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String nameAr;
  final List<String> branchIds;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.branchIds,
  });

  factory CategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameAr: data['name_ar'] ?? '',
      branchIds: List<String>.from(data['branchIds'] ?? []),
    );
  }
}
