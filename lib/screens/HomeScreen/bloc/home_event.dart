part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

final class HomeInitialFetchEvent extends HomeEvent {
  final bool isCached;

  HomeInitialFetchEvent({required this.isCached});
}

final class SubscriptionInitialFetchEvent extends HomeEvent {}

class HomeProfileButtonOnTapEvent extends HomeEvent {}

class HomePageAddToCartEvent extends HomeEvent {
  final String mealTime;
  final String mealType;

  HomePageAddToCartEvent({required this.mealTime, required this.mealType});
}

class HomePageRemoveFromCartEvent extends HomeEvent {
  final String mealTime;
  final String mealType;

  HomePageRemoveFromCartEvent({required this.mealTime, required this.mealType});
}
