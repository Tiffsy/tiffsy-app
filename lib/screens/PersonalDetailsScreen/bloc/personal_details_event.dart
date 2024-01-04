part of 'personal_details_bloc.dart';

sealed class PersonalDetailsEvent extends Equatable {
  const PersonalDetailsEvent();
  @override
  List<Object> get props => [];
}

class ContinueButtonClickedForEmailEvent extends PersonalDetailsEvent {
  final String name;
  final String mailId;
  final String number;
  const ContinueButtonClickedForEmailEvent({required this.name, required this.mailId, required this.number});
}

class ContinueButtonClickedForPhoneEvent extends PersonalDetailsEvent {
  final String name;
  final String number;
  final String mailId;
  const ContinueButtonClickedForPhoneEvent({required this.name, required this.number, required this.mailId});
}
