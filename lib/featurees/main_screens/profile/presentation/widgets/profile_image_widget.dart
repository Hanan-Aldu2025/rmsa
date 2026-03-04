// lib/featurees/main_screens/profile/presentation/views/widgets/profile_image_widget.dart

import 'package:appp/featurees/main_screens/profile/presentation/cubit/profile_cubit.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ويدجت صورة الملف الشخصي مع زر التعديل

class ProfileImageWidget extends StatelessWidget {
  final bool isGuest;
  final String imageUrl;

  const ProfileImageWidget({
    super.key,
    required this.isGuest,
    required this.imageUrl,
  });

  static const String _defaultImage =
      "https://th.bing.com/th/id/R.b2b34517339101a111716be1c203f354?rik=e5WHTShSpipi3Q&pid=ImgRaw&r=0";

  @override
  Widget build(BuildContext context) {
    final effectiveImageUrl = imageUrl.isNotEmpty ? imageUrl : _defaultImage;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: effectiveImageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) =>
                  Image.network(_defaultImage, fit: BoxFit.cover),
            ),
          ),
        ),
        if (!isGuest)
          Positioned(
            right: 4,
            bottom: 4,
            child: GestureDetector(
              onTap: () => context.read<ProfileCubit>().updateProfileImage(),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryColor,
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ),
      ],
    );
  }
}
