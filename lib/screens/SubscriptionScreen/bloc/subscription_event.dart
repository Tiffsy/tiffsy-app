part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class StartDateChoosenEvent extends SubscriptionEvent {
  final DateTime startDate;
  final int noOfdays;

  const StartDateChoosenEvent(
      {required this.startDate, required this.noOfdays});
}

class EndDateChoosenEvent extends SubscriptionEvent {
  final DateTime endDate;

  const EndDateChoosenEvent({required this.endDate});
}
