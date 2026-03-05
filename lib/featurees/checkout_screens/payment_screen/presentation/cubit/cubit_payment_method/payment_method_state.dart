class PaymentMethodState {
  final String? selectedMethodId;
  final bool isConfirmed;
  final String? errorMessage;

  const PaymentMethodState({
    this.selectedMethodId,
    this.isConfirmed = false,
    this.errorMessage,
  });

  PaymentMethodState copyWith({
    String? selectedMethodId,
    bool? isConfirmed,
    String? errorMessage,
  }) {
    return PaymentMethodState(
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      errorMessage: errorMessage,
    );
  }
}