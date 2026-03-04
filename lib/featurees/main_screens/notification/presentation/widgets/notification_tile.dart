
// lib/featurees/main_screens/notifications/presentation/views/widgets/notification_tile.dart

import 'package:appp/featurees/main_screens/notification/domain/entities/notification_entity.dart';
import 'package:appp/featurees/main_screens/notification/presentation/widgets/notification_icon.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

/// بطاقة عرض الإشعار الواحد
class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({super.key, required this.notification});

  String _formatTime(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final difference = now.difference(notification.receivedAt);

    if (difference.inMinutes < 60) {
      return timeago.format(notification.receivedAt, locale: locale);
    } else {
      return DateFormat.jm(locale).format(notification.receivedAt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTime = _formatTime(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderColor.withOpacity(0.3)
              : AppColors.primaryColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: NotificationIcon(isRead: notification.isRead),
        title: Text(
          notification.title,
          style: AppStyles.titleLora14.copyWith(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            notification.body,
            style: AppStyles.InriaSerif_14.copyWith(color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          displayTime,
          style: TextStyle(
            fontSize: 11,
            color: notification.isRead
                ? AppColors.GrayIconColor
                : AppColors.primaryColor,
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
