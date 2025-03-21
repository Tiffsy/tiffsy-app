part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeInitialFetchState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeFetchSuccessfulState extends HomeState {
  final List<MenuDataModel> menu;
  HomeFetchSuccessfulState({required this.menu});
}

final class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState({required this.error});
}

final class SubscriptionLoadingState extends HomeState {}

final class HomePageCartQuantityChangeState extends HomeState {}

final class HomeFetchSuccessfulIsCachedState extends HomeState {}

final class UpdateCartBadge extends HomeState {
  final int quantity;

  UpdateCartBadge({required this.quantity});
}
