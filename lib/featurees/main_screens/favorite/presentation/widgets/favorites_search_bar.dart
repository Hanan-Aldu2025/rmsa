// lib/featurees/main_screens/favorite/presentation/views/widgets/favorites_search_bar.dart

import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// شريط البحث في صفحة المفضلة
class FavoritesSearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final TextEditingController controller;

  const FavoritesSearchBar({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchField(
            onChanged: onSearch,
            hintText: S.of(context).search,
            controller: controller,
          ),
        ),
        const SizedBox(width: 8),

        // زر السلة
        Material(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // الانتقال إلى صفحة السلة
            },
            child: Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.whiteColor,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
