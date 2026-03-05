import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String title;
  final String description;
  final String discount;
  final DateTime startDate;
  final DateTime endDate;
  final bool applicableToAll;
  final List<String> associatedProducts;

  OfferModel({
    required this.title,
    required this.description,
    required this.discount,
    required this.startDate,
    required this.endDate,
    required this.applicableToAll,
    required this.associatedProducts,
  });

  // لتحويل البيانات من Firestore إلى الموديل
  factory OfferModel.fromMap(Map<String, dynamic> data) {
    return OfferModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      discount: data['discount'] ?? '',
      startDate: (data['startData'] as Timestamp).toDate(),
      endDate: (data['endData'] as Timestamp).toDate(),
      applicableToAll: data['applicableToAll'] ?? false,
      associatedProducts: List<String>.from(data['associatedProducts'] ?? []),
    );
  }

  // لتحويل الموديل إلى خريطة (Map) لإضافة البيانات إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'discount': discount,
      'startData': Timestamp.fromDate(startDate),
      'endData': Timestamp.fromDate(endDate),
      'applicableToAll': applicableToAll,
      'associatedProducts': associatedProducts,
       
    };
  }
}