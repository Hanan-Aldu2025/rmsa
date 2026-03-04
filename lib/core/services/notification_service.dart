// lib/core/services/notification_service.dart

import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
