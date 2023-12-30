part of 'payment_checkout_bloc.dart';

sealed class PaymentCheckoutEvent extends Equatable {
  const PaymentCheckoutEvent();

  @override
  List<Object> get props => [];
}

class PaymentCheckoutInitialEvent extends PaymentCheckoutEvent {}

class GooglePayUPIEvent extends PaymentCheckoutEvent {
  final String orderID;
  final double amount;
  const GooglePayUPIEvent({required this.orderID, required this.amount});
}
