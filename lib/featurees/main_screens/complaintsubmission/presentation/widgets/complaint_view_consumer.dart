// lib/featurees/main_screens/complaint/presentation/views/complaint_view_consumer.dart

import 'package:appp/featurees/main_screens/complaintsubmission/presentation/cubit/complaint_cubit.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/cubit/complaint_state.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/widgets/complaint_view_body.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class ComplaintViewConsumer extends StatelessWidget {
  final String uid;
  final String email;

  const ComplaintViewConsumer({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return BlocConsumer<ComplaintCubit, ComplaintState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang.sentSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

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
          child: ComplaintViewBody(uid: uid, email: email),
        );
      },
    );
  }
}
