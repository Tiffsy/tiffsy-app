part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
  
  @override
  List<Object> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {
  final String subType;
  SubscriptionInitial({required this.subType});
}
