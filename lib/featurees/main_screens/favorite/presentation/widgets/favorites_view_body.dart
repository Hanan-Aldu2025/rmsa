// lib/featurees/main_screens/favorite/presentation/views/favorites_view_body.dart

import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_state.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/widgets/empty_favorites_widget.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/widgets/favorite_item_card.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/widgets/favorites_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جسم صفحة المفضلة
class FavoritesViewBody extends StatelessWidget {
  const FavoritesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // final lang = S.of(context);
    final cubit = context.read<FavoritesCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // شريط البحث وزر السلة
          FavoritesSearchBar(
            onSearch: cubit.searchFavorites,
            controller: cubit.searchController,
          ),
          const SizedBox(height: 8),

          // قائمة المنتجات
          Expanded(
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state.products.isEmpty) {
                  return const EmptyFavoritesWidget();
                }

                return ListView.separated(
                  itemCount: state.products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    final qty = state.quantities[product.id] ?? 0;

                    return FavoriteItemCard(
                      key: ValueKey(product.id),
                      product: product,
                      quantity: qty,
                      onIncrease: () => cubit.increaseQuantity(product.id),
                      onDecrease: () => cubit.decreaseQuantity(product.id),
                      onRemove: () => cubit.toggleFavorite(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
