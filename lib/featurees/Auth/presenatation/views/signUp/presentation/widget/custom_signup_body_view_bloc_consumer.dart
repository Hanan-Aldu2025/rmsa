import 'package:appp/featurees/Auth/presenatation/cubits/signup_cubit/signup_cubit.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/signup_view_body.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/views/bottom_nav_view.dart';
import 'package:appp/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupBodyBlocConsumer extends StatelessWidget {
  const SignupBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccese) {
          //  Navigation عند نجاح التسجيل
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BottomNavView()),
          );
        }

        if (state is SignupFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupLoading,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
