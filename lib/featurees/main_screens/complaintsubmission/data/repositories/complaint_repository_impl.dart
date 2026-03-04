// lib/featurees/main_screens/complaint/data/repositories/complaint_repository_impl.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/data/datasources/complaint_remote_data_source.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/domain/entities/complaint_entity.dart';
import 'package:dartz/dartz.dart';

/// تنفيذ ComplaintRepository - يربط بين الـ Domain والـ Data Source
class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDataSource remoteDataSource;

  ComplaintRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> sendComplaint({
    required String userId,
    required String email,
    required String complaintText,
  }) async {
    try {
      await remoteDataSource.submitComplaint(
        userId: userId,
        email: email,
        complaintText: complaintText,
      );
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error submitting complaint: $e'));
    }
  }
}
