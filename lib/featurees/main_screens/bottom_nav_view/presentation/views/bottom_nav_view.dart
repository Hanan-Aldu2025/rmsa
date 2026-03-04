import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/cubit/bottom_nav_cubit.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/widgets/bottom_nav_body.dart';
import 'package:appp/featurees/main_screens/favorite/data/datasources/favorites_remote_data_source.dart';
import 'package:appp/featurees/main_screens/favorite/data/repositories/favorites_repository_impl.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/data_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/data/datasources/location_remote_data_source.dart';
import 'package:appp/featurees/main_screens/location_branches/data/repositories/location_repository_impl.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_cubit.dart';
import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// lib/presentation/bottom_nav/bottom_nav_view.dart

/// الصفحة الرئيسية للتنقل السفلي
class BottomNavView extends StatelessWidget {
  static const routeName = "BottomNavView";

  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;
    final String? uid = user?.uid; // ✅ قد يكون null للزوار

    return MultiBlocProvider(
      providers: [
        // التنقل بين التابات
        BlocProvider(create: (_) => BottomNavCubit()),

        // ✅ NotificationsCubit - فقط للمستخدمين المسجلين
        if (!isGuest) BlocProvider.value(value: getIt<NotificationsCubit>()),

        // 🧠 عقل التطبيق (HomeCubit) — للجميع
        BlocProvider(
          lazy: false,
          create: (_) {
            final repo = HomeRepositoryImpl(
              remoteDataSource: HomeRemoteDataSource(),
            );
            final cubit = HomeCubit(repository: repo);
            cubit.loadInitialData(); // تحميل البيانات مرة واحدة فقط
            return cubit;
          },
        ),

        // Favorites يعتمد على HomeCubit - فقط للمسجلين
        if (!isGuest)
          BlocProvider(
            create: (context) => FavoritesCubit(
              repository: FavoritesRepositoryImpl(
                remoteDataSource: FavoritesRemoteDataSource(),
              ),
              homeCubit: context.read<HomeCubit>(),
              uid: uid!,
            ),
          ),

        // Location Cubit - للجميع
        BlocProvider(
          create: (context) => LocationCubit(
            repository: LocationRepositoryImpl(
              remoteDataSource: LocationRemoteDataSource(),
            ),
          ),
        ),
      ],
      child: BottomNavBody(isGuest: isGuest, uid: uid),
    );
  }
}
