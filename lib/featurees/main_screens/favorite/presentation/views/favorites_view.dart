// lib/featurees/main_screens/favorite/presentation/views/favorites_view.dart

import 'package:appp/featurees/main_screens/favorite/presentation/widgets/favorites_view_consumer.dart';
import 'package:flutter/material.dart';

/// صفحة المفضلة - نقطة الدخول
class FavoritesView extends StatelessWidget {
  final String uid;

  const FavoritesView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // FavoritesCubit موجود في MultiBlocProvider في BottomNavView
    return const SafeArea(child: FavoritesViewConsumer());
  }
}
