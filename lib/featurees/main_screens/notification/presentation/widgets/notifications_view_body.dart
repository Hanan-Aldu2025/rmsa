// lib/featurees/main_screens/notifications/presentation/views/notifications_view_body.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_cubit.dart';
import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_state.dart';
import 'package:appp/featurees/main_screens/notification/presentation/widgets/empty_notifications_widget.dart';
import 'package:appp/featurees/main_screens/notification/presentation/widgets/notification_tile.dart';
import 'package:appp/featurees/main_screens/notification/presentation/widgets/notifications_appbar%20.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جسم صفحة الإشعارات
class NotificationsViewBody extends StatelessWidget {
  const NotificationsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundGraybutton,
      appBar: const NotificationsAppBar(), // ✅ استخدام الـ AppBar المخصص
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            return const EmptyNotificationsWidget();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(kHorizintalPadding),
            itemCount: state.notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];

              return Dismissible(
                key: Key(notification.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) =>
                    cubit.deleteNotification(uid, notification.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () => cubit.markAsRead(uid, notification.id),
                  child: NotificationTile(notification: notification),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
