// lib/featurees/main_screens/personal/presentation/views/personal_view.dart

import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/personal/data/datasources/personal_remote_data_source.dart';
import 'package:appp/featurees/main_screens/personal/data/repositories/personal_repository_impl.dart';
import 'package:appp/featurees/main_screens/personal/presentation/cubit/personal_cubit.dart';
import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_view_consumer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة البيانات الشخصية - نقطة الدخول
/// Personal Info Page - Entry point
class PersonalView extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String uid; // ✅ استقبال uid كمعامل إجباري

  const PersonalView({
    super.key,
    required this.userData,
    required this.uid, // ✅ يجب تمريره من المتصل
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalCubit(
        repository: PersonalRepositoryImpl(
          remoteDataSource: PersonalRemoteDataSource(),
        ),
        initialData: userData,
        uid: uid, // تمرير uid إلى الـ Cubit
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context, title: S.of(context).personal),
        body: const PersonalViewConsumer(),
      ),
    );
  }
}

// /// صفحة البيانات الشخصية - نقطة الدخول
// class PersonalView extends StatelessWidget {
//   final Map<String, dynamic> userData;

//   const PersonalView({super.key, required this.userData});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PersonalCubit(
//         initialData: userData,
//         repository: PersonalRepositoryImpl(
//           remoteDataSource: PersonalRemoteDataSource(),
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: buildAppBar(context, title: S.of(context).personal),
//         body: PersonalViewConsumer(),
//       ),
//     );
//   }
// }
