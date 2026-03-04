// lib/featurees/main_screens/complaint/domain/entities/complaint_entity.dart
import 'package:appp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// كيان الشكوى - يمثل بيانات الشكوى في طبقة التطبيق
class ComplaintEntity extends Equatable {
  final String userId;
  final String email;
  final String complaintText;
  final DateTime createdAt;
  final String status;

  const ComplaintEntity({
    required this.userId,
    required this.email,
    required this.complaintText,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [userId, email, complaintText, createdAt, status];
}

// lib/featurees/main_screens/complaint/domain/repositories/complaint_repository.dart

/// واجهة Complaint Repository - تحدد العقود التي يجب تنفيذها في طبقة البيانات
abstract class ComplaintRepository {
  /// إرسال شكوى جديدة
  Future<Either<Failure, void>> sendComplaint({
    required String userId,
    required String email,
    required String complaintText,
  });
}
