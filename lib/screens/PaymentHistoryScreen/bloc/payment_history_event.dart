part of 'payment_history_bloc.dart';

sealed class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();

  @override
  List<Object> get props => [];
}

class PaymentHistoryInitialFetchEvent extends PaymentHistoryEvent {}
