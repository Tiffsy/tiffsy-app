part of 'refund_policy_bloc.dart';

sealed class RefundPolicyState extends Equatable {
  const RefundPolicyState();
  
  @override
  List<Object> get props => [];
}

final class RefundPolicyInitial extends RefundPolicyState {}
