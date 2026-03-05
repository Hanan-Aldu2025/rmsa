import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_model.dart';

abstract class OrderTrackingRepository {
  Future<DriverModel?> getDriverByOrderId(String orderId);
}