// lib/featurees/main_screens/notifications/presentation/views/notifications_view.dart

import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_cubit.dart';
import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_state.dart';
import 'package:appp/featurees/main_screens/notification/presentation/widgets/notifications_view_body.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة الإشعارات - نقطة الدخول
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // NotificationsCubit موجود بالفعل في MultiBlocProvider
    return const NotificationsViewConsumer();
  }
}
// lib/featurees/main_screens/notifications/presentation/views/notifications_view_consumer.dart

/// المستهلك - يتفاعل مع تغييرات الحالة
class NotificationsViewConsumer extends StatelessWidget {
  const NotificationsViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return const NotificationsViewBody();
      },
    );
  }
}
