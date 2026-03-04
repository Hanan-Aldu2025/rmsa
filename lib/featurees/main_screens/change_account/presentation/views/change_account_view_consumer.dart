// lib/featurees/main_screens/change_account/presentation/views/change_account_view_consumer.dart

import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_cubit.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_state.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/views/change_account_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class ChangeAccountViewConsumer extends StatelessWidget {
  const ChangeAccountViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeAccountCubit, ChangeAccountState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.isLoading,
          child: const ChangeAccountViewBody(),
        );
      },
    );
  }
}
