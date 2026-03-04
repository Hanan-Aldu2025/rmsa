import 'package:appp/core/app.dart';
import 'package:appp/core/services/custom_bloc_observer.dart';
import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/core/services/shared_preverences_singleton.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_presentation_layer.dart';
import 'package:appp/featurees/splash/view_model/splash_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await AppPrefs.init();
//   await Firebase.initializeApp();
//   FirebaseMessaging.instance.subscribeToTopic("all_users");
//   setupGetIt();
//   Bloc.observer = AppBlocObserver();
//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => SplashViewModel())],
//       child: const AppBootstrap(),
//     ),
//   );
// }

// void main() async {

//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await NotificationService.init(); // ✅ تفعيل إشعارات Firebase
//   setupGetIt();
//   Bloc.observer = AppBlocObserver();

//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => SplashViewModel())],
//       child: const AppBootstrap(),
//     ),
//   );
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await AppPrefs.init();
//   await Firebase.initializeApp();
//   // جلب نسخة الكيوبيت من GetIt وربطها بالخدمة
//   final notifCubit = getIt<NotificationsCubit>();
//   NotificationServiceAll.init(notifCubit);
//   // 🔔 NOTIFICATIONS
//   // await NotificationServiceAll.init(
//   //   NotificationsCubit(),
//   // ); // ✅ تفعيل إشعارات Firebase
//   setupGetIt();
//   Bloc.observer = AppBlocObserver();
//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => SplashViewModel())],

//       child: const AppBootstrap(),
//     ),
//   );
// }
//----------------------------------------------------------------------------------------------

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await AppPrefs.init();
//   await Firebase.initializeApp();

//   // 1. استدعاء setupGetIt أولاً لتسجيل كل الـ Cubits والمصادر
//   setupGetIt();

//   // 2. الآن يمكنكِ جلب الكيوبيت بأمان لأن GetIt أصبح يعرفه
//   final notifCubit = getIt<NotificationsCubit>();

//   // 3. تهيئة الخدمة
//   NotificationService.init(notifCubit);

//   Bloc.observer = AppBlocObserver();

//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => SplashViewModel())],
//       child: const AppBootstrap(),
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await Firebase.initializeApp();

  // 1. استدعاء setupGetIt أولاً لتسجيل كل الـ Cubits والمصادر
  setupGetIt();

  // 2. الآن يمكنكِ جلب الكيوبيت بأمان لأن GetIt أصبح يعرفه
  final notifCubit = getIt<NotificationsCubit>();

  // 3. تهيئة خدمة الإشعارات
  NotificationService.init(notifCubit);

  // 4. بدء الاستماع للإشعارات إذا كان المستخدم مسجل الدخول
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    notifCubit.startListening(user.uid);
  }
  Bloc.observer = AppBlocObserver();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SplashViewModel())],
      child: const AppBootstrap(),
    ),
  );
}
