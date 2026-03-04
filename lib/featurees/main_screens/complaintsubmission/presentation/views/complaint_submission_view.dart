// lib/featurees/main_screens/complaint/presentation/views/complaint_submission_view.dart

import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/data/datasources/complaint_remote_data_source.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/data/repositories/complaint_repository_impl.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/cubit/complaint_cubit.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/widgets/complaint_view_consumer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة تقديم الشكوى - نقطة الدخول
class ComplaintSubmissionView extends StatelessWidget {
  final String uid;
  final String email;

  const ComplaintSubmissionView({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplaintCubit(
        repository: ComplaintRepositoryImpl(
          remoteDataSource: ComplaintRemoteDataSource(),
        ),
      ),
      child: Scaffold(
        appBar: buildAppBar(context, title: S.of(context).complaintSubmission),
        body: ComplaintViewConsumer(uid: uid, email: email),
      ),
    );
  }
}
