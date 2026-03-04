import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/views/login_view.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/cubit/bottom_nav_cubit.dart';
import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/widgets/bottom_nav_bar_icons.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/views/favorites_view.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/views/location_presentation_layer.dart';
import 'package:appp/featurees/main_screens/profile/presentation/views/profile_view.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

// lib/featurees/main_screens/bottom_nav_view/presentation/widgets/bottom_nav_body.dart

/// جسم التنقل السفلي
class BottomNavBody extends StatelessWidget {
  final bool isGuest;
  final String? uid; // ✅ اختياري

  const BottomNavBody({super.key, required this.isGuest, this.uid});

  @override
  Widget build(BuildContext context) {
    // ✅ قائمة الصفحات - ProfileView متاح للجميع الآن
    final pages = [
      HomeView(uid: uid), // index 0: الرئيسية (للجميع)

      if (!isGuest) FavoritesView(uid: uid!), // index 1: المفضلة (للمسجلين)
      if (isGuest)
        _buildGuestPlaceholder(
          // index 1: رسالة للزوار
          icon: Icons.favorite_border,
          message: 'المفضلة متاحة فقط للمستخدمين المسجلين',
          context: context,
        ),
      if (!isGuest)
        const Center(child: Text('Orders Page')), // index 2: الطلبات (للمسجلين)
      if (isGuest)
        _buildGuestPlaceholder(
          // index 1: رسالة للزوار
          icon: LucideIcons.package,
          message: 'الطلبات متاحة فقط للمستخدمين المسجلين',
          context: context,
        ),

      const LocationView(), // index 3: المواقع (للجميع)

      const ProfileView(), // index 4: الملف الشخصي (للجميع) ✅
    ];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<BottomNavCubit, int>(
        listener: (context, currentIndex) {
          FocusManager.instance.primaryFocus?.unfocus();

          switch (currentIndex) {
            case 0:
              context.read<HomeCubit>().clearSearch();
              break;
            case 1:
              if (!isGuest) {
                context.read<FavoritesCubit>().clearSearch();
                context.read<FavoritesCubit>().resetQuantities();
              }
              break;
            case 3:
              try {
                context.read<LocationCubit>().clearSearch();
              } catch (_) {}
              break;
          }
        },
        child: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return Scaffold(
              body: IndexedStack(index: currentIndex, children: pages),
              bottomNavigationBar: BottomNavBarIcons(
                currentIndex: currentIndex,
                isGuest: isGuest,
              ),
            );
          },
        ),
      ),
    );
  }

  /// عنصر placeholder للزوار
  Widget _buildGuestPlaceholder({
    required IconData icon,
    required String message,
    required BuildContext context,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: AppColors.primaryColor.withOpacity(0.5)),
          const SizedBox(height: 15),
          Text(message),
          const SizedBox(height: 50),
          CustomButton(
            text: 'تسجيل الدخول / إنشاء حساب',
            onpressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            ),
          ),
        ],
      ),
    );
  }
}
