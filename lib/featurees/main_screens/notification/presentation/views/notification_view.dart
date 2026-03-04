// import 'package:appp/core/widget/custom_build_AppBarr.dart';
// import 'package:appp/generated/l10n.dart';
// import 'package:appp/utils/app_colors.dart';
// import 'package:appp/utils/app_style.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:intl/intl.dart';

// //-----------------------------------------------------------------------------------------------

// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // --- Model ---
// class NotificationModel extends Equatable {
//   final String id;
//   final String title;
//   final String body;
//   final DateTime receivedAt;
//   final bool isRead;

//   const NotificationModel({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.receivedAt,
//     this.isRead = false,
//   });

//   @override
//   List<Object?> get props => [id, title, body, receivedAt, isRead];
// }

// // --- State ---
// class NotificationsState extends Equatable {
//   final List<NotificationModel> notifications;
//   final int unreadCount;

//   const NotificationsState({
//     this.notifications = const [],
//     this.unreadCount = 0,
//   });

//   NotificationsState copyWith({
//     List<NotificationModel>? notifications,
//     int? unreadCount,
//   }) {
//     return NotificationsState(
//       notifications: notifications ?? this.notifications,
//       unreadCount: unreadCount ?? this.unreadCount,
//     );
//   }

//   @override
//   List<Object?> get props => [notifications, unreadCount];
// }

// // --- Cubit ---
// class NotificationsCubit extends Cubit<NotificationsState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   StreamSubscription? _subscription;

//   NotificationsCubit() : super(const NotificationsState());

//   // دالة لبدء مراقبة إشعارات هذا المستخدم من Firestore (ميزة البقاء بعد الإغلاق)
//   void startListening(String uid) {
//     _subscription?.cancel();
//     _subscription = _firestore
//         .collection('user_information')
//         .doc(uid)
//         .collection('notifications')
//         .orderBy('receivedAt', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//           final notifications = snapshot.docs.map((doc) {
//             final data = doc.data();
//             return NotificationModel(
//               id: doc.id,
//               title: data['title'] ?? '',
//               body: data['body'] ?? '',
//               receivedAt:
//                   (data['receivedAt'] as Timestamp?)?.toDate() ??
//                   DateTime.now(),
//               isRead: data['isRead'] ?? false,
//             );
//           }).toList();

//           emit(
//             state.copyWith(
//               notifications: notifications,
//               unreadCount: notifications.where((n) => !n.isRead).length,
//             ),
//           );
//         });
//   }

//   // حذف الإشعار من الفيرستور ومن شريط النظام
//   Future<void> deleteNotification(String uid, String notificationId) async {
//     try {
//       await _firestore
//           .collection('user_information')
//           .doc(uid)
//           .collection('notifications')
//           .doc(notificationId)
//           .delete();

//       int? numericId = int.tryParse(notificationId);
//       if (numericId != null) {
//         NotificationServiceAll.cancelNotification(numericId);
//       }
//     } catch (e) {
//       print("Error deleting notification: $e");
//     }
//   }

//   // تحديث حالة القراءة في الفيرستور
//   Future<void> markAsRead(String uid, String notificationId) async {
//     try {
//       await _firestore
//           .collection('user_information')
//           .doc(uid)
//           .collection('notifications')
//           .doc(notificationId)
//           .update({'isRead': true});

//       int? numericId = int.tryParse(notificationId);
//       if (numericId != null) {
//         NotificationServiceAll.cancelNotification(numericId);
//       }
//     } catch (e) {
//       print("Error marking as read: $e");
//     }
//   }

//   void markAllAsRead() {
//     NotificationServiceAll.cancelAllNotifications();
//     emit(state.copyWith(unreadCount: 0));
//   }

//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     return super.close();
//   }
// }

// // 1. ملف الـ View: يستخدم للانتقال للصفحة
// class NotificationsView extends StatelessWidget {
//   const NotificationsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const NotificationsConsumer();
//   }
// }

// // 2. ملف الـ Consumer: لمراقبة الحالة (كما هو مطلوب)
// class NotificationsConsumer extends StatelessWidget {
//   const NotificationsConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NotificationsCubit, NotificationsState>(
//       builder: (context, state) {
//         return const NotificationsViewBody();
//       },
//     );
//   }
// }

// // 3. ملف الـ Body: التصميم الفعلي مع ميزة الحذف بالسحب والوقت الذكي
// class NotificationsViewBody extends StatelessWidget {
//   const NotificationsViewBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final lang = S.of(context);
//     final cubit = context.read<NotificationsCubit>();
//     final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

//     return Scaffold(
//       backgroundColor: AppColors.backgroundGraybutton,
//       appBar: buildAppBar(context, title: lang.notifications),
//       body: BlocBuilder<NotificationsCubit, NotificationsState>(
//         builder: (context, state) {
//           if (state.notifications.isEmpty) {
//             return Center(
//               child: Text(lang.noNotifications, style: AppStyles.InriaSerif_14),
//             );
//           }
//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: state.notifications.length,
//             separatorBuilder: (_, _) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final item = state.notifications[index];

//               return Dismissible(
//                 key: Key(item.id),
//                 direction: DismissDirection.endToStart,
//                 onDismissed: (direction) =>
//                     cubit.deleteNotification(uid, item.id),
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
//                   onTap: () => cubit.markAsRead(uid, item.id),
//                   child: NotificationTile(item: item),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // ويدجت عرض الإشعار المنفرد مع الوقت الذكي
// class NotificationTile extends StatelessWidget {
//   final NotificationModel item;
//   const NotificationTile({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     String locale = Localizations.localeOf(context).languageCode;
//     final now = DateTime.now();
//     final difference = now.difference(item.receivedAt);

//     String displayTime = difference.inMinutes < 60
//         ? timeago.format(item.receivedAt, locale: locale)
//         : DateFormat.jm(locale).format(item.receivedAt);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: item.isRead
//             ? Colors.white
//             : AppColors.primaryColor.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: item.isRead
//               ? AppColors.borderColor.withOpacity(0.3)
//               : AppColors.primaryColor.withOpacity(0.2),
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: _buildLeadingIcon(item.isRead),
//         title: Text(
//           item.title,
//           style: AppStyles.titleLora14.copyWith(
//             fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Text(
//             item.body,
//             style: AppStyles.InriaSerif_14.copyWith(color: Colors.grey[600]),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         trailing: Text(
//           displayTime,
//           style: TextStyle(
//             fontSize: 11,
//             color: item.isRead
//                 ? AppColors.GrayIconColor
//                 : AppColors.primaryColor,
//             fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLeadingIcon(bool isRead) {
//     return Stack(
//       children: [
//         CircleAvatar(
//           backgroundColor: isRead
//               ? Colors.grey[100]
//               : AppColors.primaryColor.withOpacity(0.1),
//           child: Icon(
//             isRead ? Icons.notifications_none : Icons.notifications_active,
//             color: isRead ? Colors.grey : AppColors.primaryColor,
//             size: 20,
//           ),
//         ),
//         if (!isRead)
//           Positioned(
//             right: 0,
//             top: 0,
//             child: Container(
//               width: 10,
//               height: 10,
//               decoration: const BoxDecoration(
//                 color: AppColors.primaryColor,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class NotificationServiceAll {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static bool _isInitialized = false;

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     importance: Importance.max,
//     playSound: true,
//   );

//   static Future<void> init(NotificationsCubit cubit) async {
//     if (_isInitialized) return;

//     await _messaging.requestPermission(alert: true, badge: true, sound: true);

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await _localNotifications.initialize(initializationSettings);

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(_channel);
//     // في ملف NotificationServiceAll داخل دالة init
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       RemoteNotification? notification = message.notification;
//       if (notification != null) {
//         final int notificationId = notification.hashCode;
//         final String? uid = FirebaseAuth.instance.currentUser?.uid;

//         if (uid != null) {
//           try {
//             // نستخدم await هنا لضمان اكتمال الحفظ قبل عرض الإشعار المحلي
//             await FirebaseFirestore.instance
//                 .collection('user_information')
//                 .doc(uid)
//                 .collection('notifications')
//                 .doc(notificationId.toString())
//                 .set({
//                   'title': notification.title,
//                   'body': notification.body,
//                   'receivedAt': FieldValue.serverTimestamp(),
//                   'isRead': false,
//                 });
//             print("✅ تم حفظ الإشعار في Firestore للمستخدم: $uid");
//           } catch (e) {
//             print("❌ خطأ أثناء حفظ الإشعار في Firestore: $e");
//           }
//         }
//         _showLocalNotification(notificationId, notification);
//       }
//     });

//     // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     //   RemoteNotification? notification = message.notification;

//     //   if (notification != null) {
//     //     final int notificationId = notification.hashCode;
//     //     final String? uid = FirebaseAuth.instance.currentUser?.uid;

//     //     if (uid != null) {
//     //       await FirebaseFirestore.instance
//     //           .collection('user_information')
//     //           .doc(uid)
//     //           .collection('notifications')
//     //           .doc(notificationId.toString())
//     //           .set({
//     //             'title': notification.title,
//     //             'body': notification.body,
//     //             'receivedAt': FieldValue.serverTimestamp(),
//     //             'isRead': false,
//     //           });
//     //     }
//     //     _showLocalNotification(notificationId, notification);
//     //   }
//     // });

//     await _messaging.subscribeToTopic("all");
//     _isInitialized = true;
//   }

//   static void _showLocalNotification(int id, RemoteNotification notification) {
//     _localNotifications.show(
//       id,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channel.id,
//           _channel.name,
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ),
//     );
//   }

//   static Future<void> cancelNotification(int id) async =>
//       await _localNotifications.cancel(id);
//   static Future<void> cancelAllNotifications() async =>
//       await _localNotifications.cancelAll();
// }
