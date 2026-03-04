// lib/featurees/main_screens/personal/presentation/views/personal_view_consumer.dart

import 'package:appp/featurees/main_screens/personal/presentation/cubit/personal_cubit.dart';
import 'package:appp/featurees/main_screens/personal/presentation/cubit/personal_state.dart';
import 'package:appp/featurees/main_screens/personal/presentation/widgets/personal_view_body.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class PersonalViewConsumer extends StatelessWidget {
  const PersonalViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return BlocConsumer<PersonalCubit, PersonalState>(
      listener: (context, state) {
        if (state is PersonalUpdateSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(lang.updateSuccess)));
          Navigator.pop(context);
        } else if (state is PersonalUpdateFailure) {
          String message;
          if (state.errorMessage == 'old_password_required') {
            message = lang.oldPasswordRequired;
          } else if (state.errorMessage.contains('wrong-password')) {
            message = lang.wrongPassword;
          } else {
            message = lang.errorOccurred;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
          // نبقى في وضع التعديل
        }
      },
      builder: (context, state) {
        Widget child;
        if (state is PersonalLoading) {
          child = const Center(child: CircularProgressIndicator());
        } else if (state is PersonalDisplay) {
          child = PersonalViewBody(isEditing: state.isEditing);
        } else {
          child = const SizedBox.shrink();
        }

        return ModalProgressHUD(
          inAsyncCall: state is PersonalLoading,
          child: child,
        );
      },
    );
  }
}
