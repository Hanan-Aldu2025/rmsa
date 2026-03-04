// lib/featurees/main_screens/notifications/data/models/notification_model.dart

import 'package:appp/featurees/main_screens/notification/domain/entities/notification_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل الإشعار - مسؤول عن تحويل البيانات من وإلى Firestore
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });

  /// تحويل من DocumentSnapshot إلى Model
  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      receivedAt:
          (data['receivedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  /// تحويل من Model إلى Entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      receivedAt: receivedAt,
      isRead: isRead,
    );
  }

  /// تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'receivedAt': Timestamp.fromDate(receivedAt),
      'isRead': isRead,
    };
  }
}
