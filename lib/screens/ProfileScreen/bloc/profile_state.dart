part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileBlocInitialState extends ProfileState {
  User user;
  ProfileBlocInitialState({required this.user});
}

class ProfileBlocInitialUserNotFoundState extends ProfileState {}

class ProfilePageButtonPressState extends ProfileState {
  final Widget newPage;

  const ProfilePageButtonPressState({required this.newPage});
}

class ProfilePageLogoutButtonOnPressState extends ProfileState {}

class ProfilePageLogoutLoadingState extends ProfileState {
  User user;
  ProfilePageLogoutLoadingState({required this.user});
}
