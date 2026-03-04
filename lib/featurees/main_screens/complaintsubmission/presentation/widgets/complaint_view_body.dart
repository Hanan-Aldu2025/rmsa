// lib/featurees/main_screens/complaint/presentation/views/complaint_view_body.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/cubit/complaint_cubit.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/widgets/complaint_submit_button.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/widgets/complaint_text_field.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جسم صفحة تقديم الشكوى
class ComplaintViewBody extends StatelessWidget {
  final String uid;
  final String email;

  const ComplaintViewBody({super.key, required this.uid, required this.email});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final cubit = context.read<ComplaintCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: Column(
        children: [
          // مسافة علوية
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),

          // حقل إدخال الشكوى
          ComplaintTextField(
            title: lang.complaintSubmission,
            hintText: lang.describeIssue,
            controller: cubit.complaintController,
          ),

          // مسافة متوسطة
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),

          // زر الإرسال
          ComplaintSubmitButton(
            onPressed: () => cubit.submitComplaint(
              userId: uid,
              email: email,
              emptyMessage: lang.pleaseWriteSomething,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
