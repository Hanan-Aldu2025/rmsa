import 'package:appp/featurees/main_screens/notification/presentation/views/notification_data_layer.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_domain_layer.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_presentation_layer.dart';
import 'package:get_it/get_it.dart';
import 'package:appp/core/services/firebase_auth_services.dart';
import 'package:appp/featurees/Auth/data/repos/auth_repos_imp.dart';
import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:appp/featurees/Auth/domain/use_case/forgot_pass_usecase.dart';

// final getIt = GetIt.instance;

// void setupGetIt() {
//   //================== Auth ==================//
//   getIt.registerSingleton<FirebaseAuthServices>(FirebaseAuthServices());

//   getIt.registerSingleton<AuthRepos>(
//     AuthReposImp(getIt<FirebaseAuthServices>()),
//   );

//   getIt.registerLazySingleton<ForgotPasswordUseCase>(
//     () => ForgotPasswordUseCase(getIt<AuthRepos>()),
//   );
//   //==================== notification ==================//
//   // تسجيل كيوبيت الإشعارات كـ Singleton (نسخة واحدة دائمة)
// }

final getIt = GetIt.instance;

void setupGetIt() {
  //================== Auth ==================//
  getIt.registerSingleton<FirebaseAuthServices>(FirebaseAuthServices());

  getIt.registerSingleton<AuthRepos>(
    AuthReposImp(getIt<FirebaseAuthServices>()),
  );

  getIt.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(getIt<AuthRepos>()),
  );

  //==================== Notifications ==================//
  // ✅ تسجيل الـ DataSource
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(),
  );

  // ✅ تسجيل الـ Repository
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: getIt<NotificationsRemoteDataSource>(),
    ),
  );

  // ✅ تسجيل الـ Cubit (كـ LazySingleton)
  getIt.registerLazySingleton<NotificationsCubit>(
    () => NotificationsCubit(repository: getIt<NotificationsRepository>()),
  );
}
