part of 'personal_details_bloc.dart';

sealed class PersonalDetailsEvent extends Equatable {
  const PersonalDetailsEvent();
  @override
  List<Object> get props => [];
}

class ContinueButtonClickedEvent extends PersonalDetailsEvent{
  final String name;
  final String mailId;
  final String phoneNumber;
  ContinueButtonClickedEvent({required this.name, required this.mailId, required this.phoneNumber});
}

