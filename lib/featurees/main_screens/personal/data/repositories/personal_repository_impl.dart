// lib/featurees/main_screens/personal/data/repositories/personal_repository_impl.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/personal/data/datasources/personal_remote_data_source.dart';
import 'package:appp/featurees/main_screens/personal/domain/repositories/personal_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// تنفيذ PersonalRepository - يربط بين الـ Domain والـ Data Source
/// PersonalRepository Implementation - connects Domain and Data Source
class PersonalRepositoryImpl implements PersonalRepository {
  final PersonalRemoteDataSource remoteDataSource;

  PersonalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> updatePersonalProfile({
    required String uid,
    required String name,
    required String phone,
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // إعادة التحقق من هوية المستخدم / Re-authenticate user
      await remoteDataSource.reauthenticateUser(user.email!, oldPassword);

      // تحديث بيانات المستخدم في Firestore / Update user data in Firestore
      await remoteDataSource.updateUserData(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
      );

      // تحديث البريد الإلكتروني إذا تغير / Update email if changed
      if (email.isNotEmpty && email != user.email) {
        await remoteDataSource.updateEmail(email);
      }

      // تحديث كلمة المرور إذا تم إدخالها / Update password if provided
      if (newPassword.isNotEmpty) {
        await remoteDataSource.updatePassword(newPassword);
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FailureServer(e.code));
    } catch (e) {
      return Left(FailureServer(e.toString()));
    }
  }
}
