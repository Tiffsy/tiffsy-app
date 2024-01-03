part of 'personal_details_bloc.dart';

sealed class PersonalDetailsEvent extends Equatable {
  const PersonalDetailsEvent();
  @override
  List<Object> get props => [];
}

class ContinueButtonClickedForEmailEvent extends PersonalDetailsEvent {
  final String name;
  final String mailId;
  const ContinueButtonClickedForEmailEvent({required this.name, required this.mailId});
}

class ContinueButtonClickedForPhoneEvent extends PersonalDetailsEvent {
  final String name;
  final String number;
  const ContinueButtonClickedForPhoneEvent({required this.name, required this.number});
}
