import 'package:appp/featurees/checkout_screens/cart_screen/data/repo/cart_repo_imp.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/repo/cart_repo.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/order_method_cubit/order_method_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:appp/core/services/firebase_auth_services.dart';
import 'package:appp/featurees/Auth/data/repos/auth_repos_imp.dart';
import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:appp/featurees/Auth/domain/use_case/forgot_pass_usecase.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/use_case/cart_use_case.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';

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

  //================== Cart ==================//
  // Repository
  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl());

  // UseCase
  getIt.registerLazySingleton<CartUseCase>(
    () => CartUseCase(getIt<CartRepository>()),
  );

  // يجب تسجيل CartCubit أولاً ثم تسجيل PointsCubit
getIt.registerFactory<CartCubit>(
  () => CartCubit(
    getIt<CartUseCase>(),  // أول معامل
  ),
);



 //====================delivery method==================//
  getIt.registerFactory<DeliveryMethodCubit>(() => DeliveryMethodCubit());
}
