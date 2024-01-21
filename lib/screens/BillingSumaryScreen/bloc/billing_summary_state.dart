part of 'billing_summary_bloc.dart';

sealed class BillingSummaryState extends Equatable {
  const BillingSummaryState();
  
  @override
  List<Object> get props => [];
}

final class BillingSummaryInitial extends BillingSummaryState {}

class TransactionLoadingState extends BillingSummaryState{}

class RazorpayInProgress extends BillingSummaryState {}

class RazorpaySuccess extends BillingSummaryState {}

class RazorpayFailure extends BillingSummaryState {
  final String errorMessage;
  RazorpayFailure({required this.errorMessage});
}

