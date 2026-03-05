import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/delivery_options_entity_and_model.dart';
import 'package:appp/featurees/main_screens/offers_screen/data/model/offer_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية
class CartInitial extends CartState {}

/// حالة التحميل
class CartLoading extends CartState {}

/// حالة تحديث السلة وخيارات التوصيل
class CartUpdated extends CartState {
  final List<CartItemEntity> items;
  final double totalPrice;
  final List<DeliveryOption> deliveryOptions;
  final String orderNote;
    final OfferModel? appliedOffer; // إضافة العروض هنا


  const CartUpdated({
    required this.items,
    required this.totalPrice,
    this.deliveryOptions = const [],
    required this.orderNote, this.appliedOffer,
  });

  @override
  List<Object?> get props => [items, totalPrice, deliveryOptions, orderNote];
}

/// تم اختيار طريقة التوصيل
class CartDeliveryOptionSelected extends CartState {
  final DeliveryOption selectedOption;
  final List<CartItemEntity> items;
  final double totalPrice;
  final String orderNote;

  const CartDeliveryOptionSelected({
    required this.selectedOption,
    required this.items,
    required this.totalPrice,
    required this.orderNote,
  });

  @override
  List<Object?> get props => [selectedOption, items, totalPrice, orderNote];
}