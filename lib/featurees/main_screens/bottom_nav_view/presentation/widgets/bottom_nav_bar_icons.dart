import 'package:appp/featurees/main_screens/bottom_nav_view/presentation/cubit/bottom_nav_cubit.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// شريط التنقل السفلي
class BottomNavBarIcons extends StatelessWidget {
  final int currentIndex;
  final bool isGuest;

  const BottomNavBarIcons({
    super.key,
    required this.currentIndex,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: const Border(
          top: BorderSide(color: Color(0xFFA6A6A7), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => context.read<BottomNavCubit>().changeTab(index),
        selectedLabelStyle: AppStyles.InriaSerif_14.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: AppStyles.InriaSerif_14,
        backgroundColor: AppColors.whiteColor,
        selectedItemColor: AppColors.blackColor,
        unselectedItemColor: AppColors.GrayIconColor,
        showUnselectedLabels: true,
        items: [
          // الرئيسية - index 0 (متاحة للجميع)
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.home, size: 24),
            label: lang.home,
          ),

          // المفضلة - index 1
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.heart, size: 24),
            label: lang.favorite,
          ),

          // الطلبات - index 2
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.package, size: 24),
            label: lang.orders,
          ),

          // المواقع - index 3 (متاحة للجميع)
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.mapPin, size: 24),
            label: lang.location,
          ),

          // الملف الشخصي - index 4
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user, size: 24),
            label: lang.profile,
          ),
        ],
      ),
    );
  }
}
