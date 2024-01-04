import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    on<ProfilePageButtonPressEvent>(
      (event, emit) {
        emit(ProfilePageButtonPressState(newPage: event.newPage));
      },
    );
    on<ProfilePageLogoutButtonOnPressEvent>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        emit(ProfilePageLogoutLoadingState(user: user!));
        Box customerBox = Hive.box("customer_box");
        customerBox.clear();
        await FirebaseAuth.instance.signOut();
        emit(ProfilePageLogoutButtonOnPressState());
      },
    );
  }
}
