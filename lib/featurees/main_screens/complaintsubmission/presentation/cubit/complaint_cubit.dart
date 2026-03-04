// lib/featurees/main_screens/complaint/presentation/cubit/complaint_cubit.dart
import 'package:appp/featurees/main_screens/complaintsubmission/domain/entities/complaint_entity.dart';
import 'package:appp/featurees/main_screens/complaintsubmission/presentation/cubit/complaint_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit المسؤول عن منطق صفحة تقديم الشكوى
class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository repository;
  final TextEditingController complaintController = TextEditingController();

  ComplaintCubit({required this.repository}) : super(const ComplaintState());

  /// إرسال الشكوى
  Future<void> submitComplaint({
    required String userId,
    required String email,
    required String emptyMessage,
  }) async {
    final text = complaintController.text.trim();

    // التحقق من أن النص غير فارغ
    if (text.isEmpty) {
      emit(state.copyWith(errorMessage: emptyMessage));
      return;
    }

    // بدء التحميل
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await repository.sendComplaint(
        userId: userId,
        email: email,
        complaintText: text,
      );

      result.fold(
        (failure) => emit(
          state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
        ),
        (_) {
          complaintController.clear();
          emit(state.copyWith(isLoading: false, isSuccess: true));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    complaintController.dispose();
    return super.close();
  }
}
