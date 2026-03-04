// lib/featurees/main_screens/favorite/presentation/views/favorites_view_consumer.dart

import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_cubit.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_state.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/widgets/favorites_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// المستهلك - يتفاعل مع تغييرات الحالة
class FavoritesViewConsumer extends StatelessWidget {
  const FavoritesViewConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          // يمكن إضافة SnackBar هنا لعرض الخطأ
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.errorMessage!)),
          // );
        }
      },
      builder: (context, state) {
        // عرض مؤشر التحميل عند التحميل الأولي
        if (state.loading && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return const FavoritesViewBody();
      },
    );
  }
}
