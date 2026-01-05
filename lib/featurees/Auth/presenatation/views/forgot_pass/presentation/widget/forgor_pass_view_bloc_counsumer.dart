import 'package:appp/featurees/Auth/presenatation/views/forgot_pass/presentation/widget/forgot_pass_view_body.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/forgot_pass_cubit/forgotpass_cubit.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/forgot_pass_cubit/forgotpass_state.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';

class ForgotPasswordBlocConsumer extends StatelessWidget {
  const ForgotPasswordBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(S.of(context).check_email)));

          Navigator.pushReplacementNamed(context, LoginView.routeName);
        } else if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is ForgotPasswordLoading,
          child: ForgotPasswordBody(emailController: emailController),
        );
      },
    );
  }
}
