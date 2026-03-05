part of 'driver_review_cubit.dart';

abstract class DriverReviewState extends Equatable {
  const DriverReviewState();

  @override
  List<Object?> get props => [];
}

class DriverReviewInitial extends DriverReviewState {}

class DriverReviewLoading extends DriverReviewState {}

class DriverReviewSuccess extends DriverReviewState {}

class DriverReviewError extends DriverReviewState {
  final String message;
  const DriverReviewError(this.message);

  @override
  List<Object?> get props => [message];
}