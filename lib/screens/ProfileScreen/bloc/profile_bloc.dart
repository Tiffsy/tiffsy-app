import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileBlocInitialEvent>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ProfileBlocInitialUserNotFoundState());
      } else {
        emit(ProfileBlocInitialState(user: user));
      }
    });

    on<ProfilePageLogoutButtonOnPressEvent>(
      (event, emit) async {
        emit(LogoutLoadingState());
        await FirebaseAuth.instance.signOut();
        emit(ProfilePageLogoutButtonOnPressState());
      },
    );
  }
}
