import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_cubit.dart';
import 'package:appp/featurees/main_screens/notification/presentation/cubit/notification_state.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AppBar مخصص لصفحة الإشعارات مع زر تحديد الكل كمقروء
class NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final cubit = context.read<NotificationsCubit>();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.blackColor,
        ),
      ),
      centerTitle: true,
      title: Text(lang.notifications, style: AppStyles.titleLora18),
      actions: [
        // زر "تحديد الكل كمقروء" - يظهر فقط إذا كان هناك إشعارات غير مقروءة
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.unreadCount > 0) {
              return IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: () => cubit.markAllAsRead(uid),
                tooltip: lang.markAllAsRead, // سنضيفها لملف الترجمة
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
