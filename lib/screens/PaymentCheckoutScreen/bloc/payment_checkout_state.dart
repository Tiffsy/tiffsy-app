part of 'payment_checkout_bloc.dart';

sealed class PaymentCheckoutState extends Equatable {
  const PaymentCheckoutState();
  
  @override
  List<Object> get props => [];
}

final class PaymentCheckoutInitial extends PaymentCheckoutState {}
