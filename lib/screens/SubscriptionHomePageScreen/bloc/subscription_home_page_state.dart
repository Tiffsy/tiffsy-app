part of 'subscription_home_page_bloc.dart';

abstract class SubscriptionHomePageState extends Equatable {
  const SubscriptionHomePageState();
  
  @override
  List<Object> get props => [];
}

final class SubscriptionHomePageInitial extends SubscriptionHomePageState {}

final class SubscriptionPageLoadingState extends SubscriptionHomePageState {}

final class SubscriptionPageErrorState extends SubscriptionHomePageState{
  final String error;
  SubscriptionPageErrorState({required this.error});
}

final class SubscriptionFetchSuccessState extends SubscriptionHomePageState{
  final List<SubscriptionDataModel> subcriptionList;
  SubscriptionFetchSuccessState({required this.subcriptionList});

}

