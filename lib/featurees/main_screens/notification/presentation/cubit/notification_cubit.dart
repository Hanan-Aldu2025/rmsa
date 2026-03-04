// lib/featurees/main_screens/notifications/presentation/cubit/notifications_cubit.dart

import 'dart:async';

import 'package:appp/core/services/notification_service.dart';
import 'package:appp/featurees/main_screens/notification/domain/repositories/notifications_repository.dart';
import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit المسؤول عن منطق صفحة الإشعارات
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;
  StreamSubscription? _subscription;

  NotificationsCubit({required this.repository})
    : super(const NotificationsState());

  /// بدء مراقبة الإشعارات للمستخدم
  void startListening(String uid) {
    emit(state.copyWith(isLoading: true));

    _subscription?.cancel();
    _subscription = repository
        .watchNotifications(uid)
        .listen(
          (notifications) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  notifications: notifications,
                  unreadCount: notifications.where((n) => !n.isRead).length,
                  isLoading: false,
                ),
              );
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  errorMessage: error.toString(),
                  isLoading: false,
                ),
              );
            }
          },
        );
  }

  /// حذف إشعار
  Future<void> deleteNotification(String uid, String notificationId) async {
    try {
      // حذف من Firestore
      final result = await repository.deleteNotification(
        uid: uid,
        notificationId: notificationId,
      );

      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.errorMessage)),
        (_) {
          // إلغاء الإشعار المحلي
          final numericId = int.tryParse(notificationId);
          if (numericId != null) {
            NotificationService.cancelNotification(numericId);
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// تحديث حالة الإشعار إلى مقروء
  Future<void> markAsRead(String uid, String notificationId) async {
    try {
      final result = await repository.markAsRead(
        uid: uid,
        notificationId: notificationId,
      );

      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.errorMessage)),
        (_) {
          final numericId = int.tryParse(notificationId);
          if (numericId != null) {
            NotificationService.cancelNotification(numericId);
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// تحديث جميع الإشعارات إلى مقروءة
  Future<void> markAllAsRead(String uid) async {
    try {
      final result = await repository.markAllAsRead(uid);

      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.errorMessage)),
        (_) {
          NotificationService.cancelAllNotifications();
          emit(state.copyWith(unreadCount: 0));
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
