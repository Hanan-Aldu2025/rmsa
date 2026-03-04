// lib/featurees/main_screens/notifications/presentation/cubit/notifications_state.dart

import 'dart:async';

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_domain_layer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

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

// lib/featurees/main_screens/notifications/presentation/cubit/notifications_cubit.dart

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

// lib/featurees/main_screens/notifications/presentation/views/notifications_view.dart

/// صفحة الإشعارات - نقطة الدخول
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // NotificationsCubit موجود بالفعل في MultiBlocProvider
    return const NotificationsViewConsumer();
  }
}
// lib/featurees/main_screens/notifications/presentation/views/notifications_view_consumer.dart

/// المستهلك - يتفاعل مع تغييرات الحالة
class NotificationsViewConsumer extends StatelessWidget {
  const NotificationsViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return const NotificationsViewBody();
      },
    );
  }
}

// lib/featurees/main_screens/notifications/presentation/views/notifications_view_body.dart

/// جسم صفحة الإشعارات
class NotificationsViewBody extends StatelessWidget {
  const NotificationsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundGraybutton,
      appBar: const NotificationsAppBar(), // ✅ استخدام الـ AppBar المخصص
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            return const EmptyNotificationsWidget();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(kHorizintalPadding),
            itemCount: state.notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];

              return Dismissible(
                key: Key(notification.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) =>
                    cubit.deleteNotification(uid, notification.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () => cubit.markAsRead(uid, notification.id),
                  child: NotificationTile(notification: notification),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// class NotificationsViewBody extends StatelessWidget {
//   const NotificationsViewBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);
//     final cubit = context.read<NotificationsCubit>();
//     final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

//     return Scaffold(
//       backgroundColor: AppColors.backgroundGraybutton,
//       appBar: buildAppBar(
//         context,
//         title: lang.notifications,
//         actions: [
//           if (context.watch<NotificationsCubit>().state.notifications.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.done_all),
//               onPressed: () => cubit.markAllAsRead(uid),
//               tooltip: lang.markAllAsRead,
//             ),
//         ],
//       ),
//       body: BlocBuilder<NotificationsCubit, NotificationsState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.notifications.isEmpty) {
//             return const EmptyNotificationsWidget();
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: state.notifications.length,
//             separatorBuilder: (_, _) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final notification = state.notifications[index];

//               return Dismissible(
//                 key: Key(notification.id),
//                 direction: DismissDirection.endToStart,
//                 onDismissed: (direction) =>
//                     cubit.deleteNotification(uid, notification.id),
//                 background: Container(
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.only(right: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.delete, color: Colors.white),
//                 ),
//                 child: GestureDetector(
//                   onTap: () => cubit.markAsRead(uid, notification.id),
//                   child: NotificationTile(notification: notification),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// lib/featurees/main_screens/notifications/presentation/views/widgets/notification_icon.dart

/// أيقونة الإشعار مع نقطة الحالة
class NotificationIcon extends StatelessWidget {
  final bool isRead;

  const NotificationIcon({super.key, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: isRead
              ? Colors.grey[100]
              : AppColors.primaryColor.withOpacity(0.1),
          child: Icon(
            isRead ? Icons.notifications_none : Icons.notifications_active,
            color: isRead ? Colors.grey : AppColors.primaryColor,
            size: 20,
          ),
        ),
        if (!isRead)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// lib/featurees/main_screens/notifications/presentation/views/widgets/notification_tile.dart

/// بطاقة عرض الإشعار الواحد
class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({super.key, required this.notification});

  String _formatTime(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final difference = now.difference(notification.receivedAt);

    if (difference.inMinutes < 60) {
      return timeago.format(notification.receivedAt, locale: locale);
    } else {
      return DateFormat.jm(locale).format(notification.receivedAt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTime = _formatTime(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderColor.withOpacity(0.3)
              : AppColors.primaryColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: NotificationIcon(isRead: notification.isRead),
        title: Text(
          notification.title,
          style: AppStyles.titleLora14.copyWith(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            notification.body,
            style: AppStyles.InriaSerif_14.copyWith(color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          displayTime,
          style: TextStyle(
            fontSize: 11,
            color: notification.isRead
                ? AppColors.GrayIconColor
                : AppColors.primaryColor,
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// lib/featurees/main_screens/notifications/presentation/views/widgets/empty_notifications_widget.dart

/// عنصر عرض عند عدم وجود إشعارات
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.GrayIconColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            lang.noNotifications,
            style: AppStyles.InriaSerif_16.copyWith(
              color: AppColors.GrayIconColor,
            ),
          ),
        ],
      ),
    );
  }
}

// lib/core/services/notification_service.dart

/// خدمة الإشعارات المركزية
class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    playSound: true,
  );

  /// تهيئة خدمة الإشعارات
  static Future<void> init(NotificationsCubit cubit) async {
    if (_isInitialized) return;

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(initializationSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // الاستماع للإشعارات أثناء فتح التطبيق
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    await _messaging.subscribeToTopic("all_users");
    _isInitialized = true;
  }

  /// معالجة الإشعارات أثناء فتح التطبيق
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final notificationId = notification.hashCode;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        // حفظ الإشعار في Firestore
        await FirebaseFirestore.instance
            .collection('user_information')
            .doc(uid)
            .collection('notifications')
            .doc(notificationId.toString())
            .set({
              'title': notification.title,
              'body': notification.body,
              'receivedAt': FieldValue.serverTimestamp(),
              'isRead': false,
            });

        // عرض الإشعار المحلي
        _showLocalNotification(notificationId, notification);
      } catch (e) {
        print("❌ خطأ أثناء حفظ الإشعار: $e");
      }
    }
  }

  /// عرض الإشعار محلياً
  static void _showLocalNotification(int id, RemoteNotification notification) {
    _localNotifications.show(
      id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  /// إلغاء إشعار معين
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// إلغاء جميع الإشعارات
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}

/// AppBar مخصص لصفحة الإشعارات مع زر تحديد الكل كمقروء
class NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final cubit = context.read<NotificationsCubit>();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.blackColor,
        ),
      ),
      centerTitle: true,
      title: Text(lang.notifications, style: AppStyles.titleLora18),
      actions: [
        // زر "تحديد الكل كمقروء" - يظهر فقط إذا كان هناك إشعارات غير مقروءة
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.unreadCount > 0) {
              return IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: () => cubit.markAllAsRead(uid),
                tooltip: lang.markAllAsRead, // سنضيفها لملف الترجمة
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
