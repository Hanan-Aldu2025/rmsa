// lib/featurees/main_screens/change_account/presentation/views/change_account_view.dart

import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/change_account/data/datasources/change_account_remote_data_source.dart';
import 'package:appp/featurees/main_screens/change_account/data/repositories/change_account_repository_impl.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_cubit.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/views/change_account_view_consumer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة تبديل الحساب - نقطة الدخول
class ChangeAccountView extends StatelessWidget {
  const ChangeAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeAccountCubit(
        repository: ChangeAccountRepositoryImpl(
          remoteDataSource: ChangeAccountRemoteDataSource(),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context, title: S.of(context).changeAccount),
        body: const ChangeAccountViewConsumer(),
      ),
    );
  }
}
