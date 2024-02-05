part of 'billing_summary_bloc.dart';

abstract class BillingSummaryEvent extends Equatable {
  const BillingSummaryEvent();

  @override
  List<Object> get props => [];
}

class CouponFetchEvent extends BillingSummaryEvent{}
class InitializePaymentEvent extends BillingSummaryEvent {
  final double amount;
  InitializePaymentEvent({required this.amount});
}

class PaymentSuccessEvent extends BillingSummaryEvent {
  final String paymentId;
  PaymentSuccessEvent({required this.paymentId});
}

class PaymentFailureEvent extends BillingSummaryEvent {
  final String errorMessage;
  PaymentFailureEvent({required this.errorMessage});
}
