part of 'subscription_home_page_bloc.dart';

abstract class SubscriptionHomePageEvent extends Equatable {
  const SubscriptionHomePageEvent();

  @override
  List<Object> get props => [];
}

final class SubcriptionInitialFetchEvent extends SubscriptionHomePageEvent{}

