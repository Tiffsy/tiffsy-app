part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileBlocInitialEvent extends ProfileEvent {}

class ProfilePageButtonPressEvent extends ProfileEvent {
  final Widget newPage;

  const ProfilePageButtonPressEvent({required this.newPage});
}

class ProfilePageLogoutButtonOnPressEvent extends ProfileEvent {}
