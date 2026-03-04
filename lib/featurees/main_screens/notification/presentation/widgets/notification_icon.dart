
// lib/featurees/main_screens/notifications/presentation/views/widgets/notification_icon.dart

import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// أيقونة الإشعار مع نقطة الحالة
class NotificationIcon extends StatelessWidget {
  final bool isRead;

  const NotificationIcon({super.key, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: isRead
              ? Colors.grey[100]
              : AppColors.primaryColor.withOpacity(0.1),
          child: Icon(
            isRead ? Icons.notifications_none : Icons.notifications_active,
            color: isRead ? Colors.grey : AppColors.primaryColor,
            size: 20,
          ),
        ),
        if (!isRead)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
