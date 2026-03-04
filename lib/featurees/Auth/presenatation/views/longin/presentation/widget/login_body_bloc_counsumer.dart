import 'package:appp/featurees/Auth/presenatation/cubits/login_cubit/login_state.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/views/bottom_nav_view.dart';
import 'package:appp/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'login_view_body.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/login_cubit/login_cubit.dart';

class LoginBodyBlocConsumer extends StatelessWidget {
  const LoginBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BottomNavView()),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is LoginLoading,
          child: const LoginViewBody(),
        );
      },
    );
  }
}
