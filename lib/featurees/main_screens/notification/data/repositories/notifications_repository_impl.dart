// lib/featurees/main_screens/notifications/data/repositories/notifications_repository_impl.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/notification/data/datasources/notifications_remote_data_source.dart';
import 'package:appp/featurees/main_screens/notification/domain/entities/notification_entity.dart';
import 'package:appp/featurees/main_screens/notification/domain/repositories/notifications_repository.dart';
import 'package:dartz/dartz.dart';

/// تنفيذ NotificationsRepository
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<NotificationEntity>> watchNotifications(String uid) {
    return remoteDataSource
        .watchNotifications(uid)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.deleteNotification(
        uid: uid,
        notificationId: notificationId,
      );
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error deleting notification: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.markAsRead(
        uid: uid,
        notificationId: notificationId,
      );
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error marking as read: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String uid) async {
    try {
      await remoteDataSource.markAllAsRead(uid);
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error marking all as read: $e'));
    }
  }
}
