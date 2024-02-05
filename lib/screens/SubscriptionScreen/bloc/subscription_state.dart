part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {}

class NewDatesState extends SubscriptionState {
  final DateTime startDate;
  final DateTime endDate;

  const NewDatesState({required this.startDate, required this.endDate});
}

class EmptyState extends SubscriptionState {}
class CouponFetchSuccessState extends SubscriptionState{
  final List<CouponDataModel> couponList;
  CouponFetchSuccessState({required this.couponList});
}
class fetchErrorState extends SubscriptionState{
  final String error;  
  fetchErrorState({required this.error});
}
class fetchLoadingState extends SubscriptionState{}