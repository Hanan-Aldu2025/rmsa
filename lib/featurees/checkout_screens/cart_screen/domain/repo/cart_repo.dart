import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';

abstract class CartRepository {
  List<CartItemEntity> get items;
  double get totalPrice;

  void addToCart(ProductEntity product, {Map<String, dynamic>? selectedOptions});
  void removeFromCart(ProductEntity product, {Map<String, dynamic>? selectedOptions});
  void updateQuantity(ProductEntity product, int newQuantity, {Map<String, dynamic>? selectedOptions});
  void clearCart();
  
//   void updateCartItemQuantity(ProductEntity product, int newQuantity, {Map<String, dynamic>? selectedOptions});
//   void decreaseCartItemQuantity(ProductEntity product, {Map<String, dynamic>? selectedOptions});
 }