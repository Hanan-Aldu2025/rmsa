// lib/featurees/main_screens/profile/presentation/views/profile_view.dart

import 'package:appp/featurees/main_screens/profile/data/datasources/profile_remote_data_source.dart';
import 'package:appp/featurees/main_screens/profile/data/repositories/profile_repository_impl.dart';
import 'package:appp/featurees/main_screens/profile/presentation/cubit/profile_cubit.dart';
import 'package:appp/featurees/main_screens/profile/presentation/widgets/profile_view_consumer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// lib/featurees/main_screens/profile/presentation/views/profile_view.dart

/// صفحة الملف الشخصي - نقطة الدخول

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;
    final String? uid = user?.uid;

    return BlocProvider(
      create: (context) => ProfileCubit(
        repository: ProfileRepositoryImpl(
          remoteDataSource: ProfileRemoteDataSource(),
        ),
        uid: uid,
        isGuest: isGuest,
      ),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: ProfileViewConsumer(),
      ),
    );
  }
}
