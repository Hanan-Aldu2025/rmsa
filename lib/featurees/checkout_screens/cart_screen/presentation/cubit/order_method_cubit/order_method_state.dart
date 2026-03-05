class DilveryMethodState {
  final String? selectedMethod; // pickup / drive_thru / delivery
  final String? selectedDeliveryType; // standard / fast
  final double deliveryPrice; // رسوم التوصيل

  DilveryMethodState({
    this.selectedMethod,
    this.selectedDeliveryType,
    this.deliveryPrice = 0,
  });

  DilveryMethodState copyWith({
    String? selectedMethod,
    String? selectedDeliveryType,
    double? deliveryPrice,
  }) {
    return DilveryMethodState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedDeliveryType: selectedDeliveryType ?? this.selectedDeliveryType,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
    );
  }
}
