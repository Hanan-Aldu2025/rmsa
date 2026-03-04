// lib/featurees/main_screens/profile/presentation/views/profile_view_body.dart

import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';
import 'package:appp/featurees/main_screens/profile/presentation/widgets/profile_image_widget.dart';
import 'package:appp/featurees/main_screens/profile/presentation/widgets/profile_menu_list.dart';
import 'package:flutter/material.dart';
// lib/featurees/main_screens/profile/presentation/views/profile_view_body.dart

/// جسم صفحة الملف الشخصي

class ProfileViewBody extends StatelessWidget {
  final UserEntity user;
  final bool isGuest;

  const ProfileViewBody({super.key, required this.user, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileImageWidget(isGuest: isGuest, imageUrl: user.profileImage),
            const SizedBox(height: 15),
            ProfileMenuList(isGuest: isGuest, user: user),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
