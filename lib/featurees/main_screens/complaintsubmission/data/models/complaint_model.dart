// lib/featurees/main_screens/complaint/data/models/complaint_model.dart
import 'package:appp/featurees/main_screens/complaintsubmission/domain/entities/complaint_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل الشكوى - مسؤول عن تحويل البيانات من وإلى Firestore
class ComplaintModel {
  final String userId;
  final String email;
  final String complaintText;
  final DateTime createdAt;
  final String status;

  const ComplaintModel({
    required this.userId,
    required this.email,
    required this.complaintText,
    required this.createdAt,
    required this.status,
  });

  /// تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'complaintText': complaintText,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  /// تحويل من Map (من Firestore) إلى Model
  factory ComplaintModel.fromMap(Map<String, dynamic> map, String id) {
    return ComplaintModel(
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      complaintText: map['complaintText'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }

  /// تحويل من Model إلى Entity
  ComplaintEntity toEntity() {
    return ComplaintEntity(
      userId: userId,
      email: email,
      complaintText: complaintText,
      createdAt: createdAt,
      status: status,
    );
  }
}
