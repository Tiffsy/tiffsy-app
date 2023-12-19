part of 'billing_summary_bloc.dart';

sealed class BillingSummaryState extends Equatable {
  const BillingSummaryState();
  
  @override
  List<Object> get props => [];
}

final class BillingSummaryInitial extends BillingSummaryState {}
