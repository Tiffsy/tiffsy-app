part of 'refund_bloc.dart';

abstract class RefundEvent extends Equatable {
  const RefundEvent();

  @override
  List<Object> get props => [];
}

class RefundInitialFetchEvent extends RefundEvent {}

