part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}
final class HomeInitialFetchEvent extends HomeEvent{}
final class SubscriptionInitialFetchEvent extends HomeEvent{}
class HomeProfileButtonOnTapEvent extends HomeEvent {}

class HomePageChangeEvent extends HomeEvent {
  final int newIndex;

  HomePageChangeEvent({required this.newIndex});
}

