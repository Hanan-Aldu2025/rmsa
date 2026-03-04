// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class TestView extends StatelessWidget {
//   static const routeName = "TestView";

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController bodyController = TextEditingController();
//   TestView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("إرسال إشعار")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: "عنوان الإشعار"),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: bodyController,
//               decoration: InputDecoration(labelText: "نص الإشعار"),
//               maxLines: 3,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 NotificationService.sendNotification(
//                   title: titleController.text,
//                   body: bodyController.text,
//                 );
//               },
//               child: Text("إرسال الإشعار"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //----------------------------------notification service----------------------------
// class AdminNotificationView extends StatelessWidget {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController bodyController = TextEditingController();

//   AdminNotificationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("إرسال إشعار")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: "عنوان الإشعار"),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: bodyController,
//               decoration: InputDecoration(labelText: "نص الإشعار"),
//               maxLines: 3,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 NotificationService.sendNotification(
//                   title: titleController.text,
//                   body: bodyController.text,
//                 );
//               },
//               child: Text("إرسال الإشعار"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//       playSound: true,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initSettings);

//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     await messaging.requestPermission(alert: true, badge: true, sound: true);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {
//         sendNotification(
//           title: notification.title ?? "",
//           body: notification.body ?? "",
//         );
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
//   }

//   static Future<void> sendNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           channelDescription:
//               'This channel is used for important notifications.',
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//         );

//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformDetails,
//     );
//   }

//   static Future<String?> getToken() async {
//     return await FirebaseMessaging.instance.getToken();
//   }
// }

// //-----------------------------notification service all users-----------------------------
// // class NotificationServiceAll {
// //   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

// //   static Future<void> init() async {
// //     // 1. طلب إذن من المستخدم لإظهار الإشعارات
// //     await _messaging.requestPermission(alert: true, badge: true, sound: true);

// //     // 2. سطر السحر: الاشتراك في قناة عامة اسمها "all"
// //     // أي جهاز ينفذ هذا السطر سيستقبل أي إشعار يرسل لهذه القناة
// //     await _messaging.subscribeToTopic("all");

// //     // 3. معالجة الإشعار والتطبيق مفتوح (اختياري لجعل الإشعار يظهر والبرنامج شغال)
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       print("وصل إشعار جديد: ${message.notification?.title}");
// //     });
// //   }
// // }
