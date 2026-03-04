// lib/featurees/main_screens/personal/presentation/cubit/personal_state.dart
import 'package:equatable/equatable.dart';

// lib/featurees/main_screens/personal/presentation/cubit/personal_state.dart

/// حالات صفحة البيانات الشخصية
abstract class PersonalState extends Equatable {
  const PersonalState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class PersonalInitial extends PersonalState {}

/// حالة التحميل
class PersonalLoading extends PersonalState {}

/// حالة نجاح التحديث
class PersonalUpdateSuccess extends PersonalState {}

/// حالة فشل التحديث
class PersonalUpdateFailure extends PersonalState {
  final String errorMessage;
  const PersonalUpdateFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

/// حالة عرض النموذج مع وضع التعديل
class PersonalDisplay extends PersonalState {
  final bool isEditing;
  final Map<String, dynamic> initialData;

  const PersonalDisplay({required this.isEditing, required this.initialData});

  @override
  List<Object?> get props => [isEditing, initialData];
}
// abstract class PersonalState extends Equatable {
//   const PersonalState();

//   @override
//   List<Object?> get props => [];
// }

// /// الحالة الأولية
// class PersonalInitial extends PersonalState {}

// /// حالة التحميل
// class PersonalLoading extends PersonalState {}

// /// حالة نجاح التحديث
// class PersonalUpdateSuccess extends PersonalState {}

// /// حالة فشل التحديث
// class PersonalUpdateFailure extends PersonalState {
//   final String errorMessage;

//   const PersonalUpdateFailure({required this.errorMessage});

//   @override
//   List<Object?> get props => [errorMessage];
// }
