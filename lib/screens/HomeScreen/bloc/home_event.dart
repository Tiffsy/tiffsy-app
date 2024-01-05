part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

final class HomeInitialFetchEvent extends HomeEvent {}

final class SubscriptionInitialFetchEvent extends HomeEvent {}

class HomeProfileButtonOnTapEvent extends HomeEvent {}

class HomePageCartQuantityChangeEvent extends HomeEvent {
  final String mealType;
  final bool isIncreased;

  HomePageCartQuantityChangeEvent(
      {required this.mealType, required this.isIncreased});
}
