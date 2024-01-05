part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
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
