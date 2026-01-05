import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/widget/login_body_bloc_counsumer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/login_cubit/login_cubit.dart';
import 'package:appp/core/services/get_it_services.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const routeName = "LoginView";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt.get<AuthRepos>()),
      child: Scaffold(
        appBar: buildAppBar(context, title: S.of(context).login),
        body: const LoginBodyBlocConsumer(),
      ),
    );
  }
}
