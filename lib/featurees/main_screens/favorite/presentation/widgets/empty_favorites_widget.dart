// lib/featurees/main_screens/favorite/presentation/views/widgets/empty_favorites_widget.dart

import 'package:appp/utils/app_colors.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';

/// عنصر عرض عند عدم وجود منتجات في المفضلة
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد منتجات في المفضلة',
        style: AppStyles.titleLora18.copyWith(color: AppColors.GrayIconColor),
      ),
    );
  }
}
