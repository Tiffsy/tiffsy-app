part of 'personal_details_bloc.dart';

sealed class PersonalDetailsState extends Equatable {
  const PersonalDetailsState();
  
  @override
  List<Object> get props => [];
}

final class PersonalDetailsInitial extends PersonalDetailsState {}
final class ScreenLoadingScreen extends PersonalDetailsState{}
final class ScreenErrorState extends PersonalDetailsState{
  final String error;
  ScreenErrorState({required this.error});
}
final class ContinueButtonClickedSuccessState extends PersonalDetailsState{}





