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
class CouponFetchSuccessState extends BillingSummaryState{
  final List<CouponDataModel> couponList;
  CouponFetchSuccessState({required this.couponList});
}
class fetchLoadingState extends BillingSummaryState{}
class fetchErrorState extends BillingSummaryState{
  final String error;
  
  fetchErrorState({required this.error});

}
