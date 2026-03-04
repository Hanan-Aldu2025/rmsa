// lib/featurees/main_screens/contact_us/presentation/views/contact_us_view.dart

import 'package:appp/core/services/url_launcher_service.dart';
import 'package:appp/core/widget/custom_build_AppBarr.dart';
import 'package:appp/featurees/main_screens/contact_us/data/repositories/contact_repository_impl.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/widgets/contact_us_view_consumer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة تواصل معنا - نقطة الدخول
class ContactUsView extends StatelessWidget {
  final BranchEntity selectedBranch;

  const ContactUsView({super.key, required this.selectedBranch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // إنشاء الـ Repository مع الـ Service
        final repository = ContactRepositoryImpl(UrlLauncherServiceImpl());

        // إنشاء الـ Cubit مع الـ Repository والفرع
        return ContactCubit(repository: repository, branch: selectedBranch);
      },
      child: Scaffold(
        appBar: buildAppBar(context, title: S.of(context).contactUs),
        body: const ContactUsViewConsumer(),
      ),
    );
  }
}
