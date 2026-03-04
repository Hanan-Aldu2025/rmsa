
import 'package:appp/featurees/main_screens/notification/domain/entities/notification_entity.dart';
import 'package:equatable/equatable.dart';

/// حالات صفحة الإشعارات
class NotificationsState extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    unreadCount,
    isLoading,
    errorMessage,
  ];
}
