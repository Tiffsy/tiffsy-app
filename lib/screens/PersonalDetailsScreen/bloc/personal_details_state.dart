part of 'personal_details_bloc.dart';

sealed class PersonalDetailsState extends Equatable {
  const PersonalDetailsState();
  
  @override
  List<Object> get props => [];
}

final class PersonalDetailsInitial extends PersonalDetailsState {}
