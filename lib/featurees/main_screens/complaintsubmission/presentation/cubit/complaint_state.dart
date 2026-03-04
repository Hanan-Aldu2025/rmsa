import 'package:equatable/equatable.dart';

/// حالات صفحة تقديم الشكوى
class ComplaintState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ComplaintState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  ComplaintState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ComplaintState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}
