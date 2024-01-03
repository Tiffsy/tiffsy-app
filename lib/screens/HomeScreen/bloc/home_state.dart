part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeInitialFetchState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeFetchSuccessfulState extends HomeState {
  List<MenuDataModel> menu;
  HomeFetchSuccessfulState({required this.menu});
}

final class HomeErrorState extends HomeState{}

final class SubscriptionLoadingState extends HomeState{}

class HomeProfileButtonOnTapState extends HomeState {}

class HomePageChangeState extends HomeState {
  final int newIndex;

  HomePageChangeState({required this.newIndex});
}
