import 'package:appp/featurees/Auth/presenatation/views/forgot_pass/presentation/widget/forgor_pass_view_bloc_counsumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appp/core/services/get_it_services.dart';
import 'package:appp/featurees/Auth/domain/use_case/forgot_pass_usecase.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/forgot_pass_cubit/forgotpass_cubit.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(
        forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      ),
      child:  Scaffold(
              appBar: AppBar(title: Text("Forgot Password")),
             body: ForgotPasswordBlocConsumer(),
      ),
    );
  }
}