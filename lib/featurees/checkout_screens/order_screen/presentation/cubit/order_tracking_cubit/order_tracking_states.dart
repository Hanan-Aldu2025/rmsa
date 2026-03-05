import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';

abstract class OrderTrackingState {}

class OrderTrackingLoading extends OrderTrackingState {}

class OrderTrackingLoaded extends OrderTrackingState with EquatableMixin {
  final OrderEntity order;
  final int etaMinutes; // الوقت المتوقع بالدقائق

  OrderTrackingLoaded(this.order, this.etaMinutes);

  @override
  List<Object?> get props => [order, etaMinutes];
}

class OrderTrackingHidden extends OrderTrackingState {}

class OrderTrackingError extends OrderTrackingState {
  final String message;
  OrderTrackingError(this.message);
}