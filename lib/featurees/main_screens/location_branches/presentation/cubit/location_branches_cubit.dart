// lib/featurees/main_screens/location/presentation/cubit/location_cubit.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/domain/repositories/location_repository.dart';
import 'package:appp/featurees/main_screens/location_branches/presentation/cubit/location_branches_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit المسؤول عن منطق صفحة المواقع
class LocationCubit extends Cubit<LocationState> {
  final LocationRepository repository;
  final TextEditingController searchController = TextEditingController();

  List<BranchEntity> _allBranches = [];

  LocationCubit({required this.repository}) : super(LocationLoading());

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  /// جلب جميع الفروع
  Future<void> fetchBranches({BranchEntity? homeSelectedBranch}) async {
    try {
      if (isClosed) return;
      emit(LocationLoading());

      _allBranches = await repository.getAllBranches();

      if (isClosed) return;

      emit(
        LocationLoaded(
          allBranches: _allBranches,
          filteredBranches: [],
          selectedBranch:
              homeSelectedBranch ??
              (_allBranches.isNotEmpty ? _allBranches.first : null),
          isSearching: false,
        ),
      );
    } catch (e) {
      if (!isClosed) emit(LocationError(e.toString()));
    }
  }

  /// البحث في الفروع
  void searchBranches(String query) {
    if (isClosed || state is! LocationLoaded) return;

    final currentState = state as LocationLoaded;

    if (query.isEmpty) {
      emit(currentState.copyWith(filteredBranches: [], isSearching: false));
      return;
    }

    final filtered = _allBranches
        .where(
          (b) =>
              b.name.toLowerCase().contains(query.toLowerCase()) ||
              b.nameAr.contains(query),
        )
        .toList();

    emit(currentState.copyWith(filteredBranches: filtered, isSearching: true));
  }

  /// مسح البحث
  void clearSearch() {
    searchController.clear();
    if (state is LocationLoaded) {
      emit(
        (state as LocationLoaded).copyWith(
          filteredBranches: [],
          isSearching: false,
        ),
      );
    }
  }

  /// اختيار فرع معين
  void selectBranch(BranchEntity branch) {
    if (isClosed || state is! LocationLoaded) return;

    emit(
      (state as LocationLoaded).copyWith(
        selectedBranch: branch,
        isSearching: false,
        filteredBranches: [],
      ),
    );
  }
}
