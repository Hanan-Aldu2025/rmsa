
// lib/featurees/main_screens/notifications/presentation/views/widgets/empty_notifications_widget.dart

import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// عنصر عرض عند عدم وجود إشعارات
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.GrayIconColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            lang.noNotifications,
            style: AppStyles.InriaSerif_16.copyWith(
              color: AppColors.GrayIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
