import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:tiffsy_app/screens/LoginScreen/repository/user_repo.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  UserRepo userRepo = UserRepo();
  UserCredential? userCredential;
  LoginBloc(super.initialState) {

    on<SendOtpToPhoneEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await userRepo.signInWithPhoneNumber(
            phoneNumber: event.phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              add(OnPhoneAuthVerificationCompletedEvent(
                  credential: credential));
            },
            verificationFailed: (FirebaseAuthException e) {
              add(OnPhoneAuthErrorEvent(error: e.toString()));
            },
            codeSent: (String verificationId, int? refreshToken) {
              add(OnPhoneOtpSend(
                  verificationId: verificationId, token: refreshToken));
            },
            codeAutoRetrievalTimeout: (String verificationId, ) {
            });
      } catch (err) {
        emit(AuthErrorState(err.toString()));
      }
    });

    on<OnPhoneOtpSend>((event, emit) {
      emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId));
    });

    on<VerifySentOtp>(((event, emit) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId, smsCode: event.optCode);
        add(OnPhoneAuthVerificationCompletedEvent(credential: credential));
      } catch (err) {
        emit(AuthErrorState(err.toString()));
      }
    }));

    on<OnPhoneAuthErrorEvent>((event, emit) {
      emit(AuthErrorState(event.error.toString()));
    });

    on<OnPhoneAuthVerificationCompletedEvent>((event, emit) async {
      try {
        await userRepo.firebaseAuth
            .signInWithCredential(event.credential)
            .then((value) {
          final user = FirebaseAuth.instance.currentUser!;
          String cstPhone = user.phoneNumber.toString();
          cstPhone = cstPhone.substring(3);

          print(user.phoneNumber);
          add(CheckPreviousPhoneEvent(
              phoneNumber: cstPhone));
          // emit(LoginScreenLoadedState());
        });
      } catch (err) {
        emit(AuthErrorState(err.toString()));
      }
    });
   
    on<SignInWithGooglePressedEvent>(((event, emit) async {
      
      try {
        final GoogleSignInAccount? googleUser =
            await userRepo.googleSignIn.signIn();
        if (googleUser == null) {
          emit(AuthErrorState("Google User id null"));
        }
        emit(AuthLoadingState());
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        try {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            final user = FirebaseAuth.instance.currentUser!;
            add(CheckPreviousEmailEvent(mailId: user.email.toString()));
          });
        } catch (e) {
          emit(AuthErrorState(e.toString()));
        }
      } catch (err) {
        emit(AuthErrorState(err.toString()));
      }
    }));

    on<CheckPreviousPhoneEvent>((event, emit) async {
      try {
        bool isPresent =
            await userRepo.checkPhoneNumber(phoneNumber: event.phoneNumber);
        if (!isPresent) {
          try {
            await userRepo.storePhoneNumber(phoneNumber: event.phoneNumber);
            emit(LoginScreenLoadedState());
          } catch (err) {
            emit(AuthErrorState(err.toString()));
          }
        } else {
          emit(LoadHomeScreenState());
        }
      } catch (err) {
        emit(AuthErrorState(err.toString()));
      }
    });

    on<CheckPreviousEmailEvent>((event, emit) async {
      try {
        bool isPresent = await userRepo.checkEmail(mailId: event.mailId);
        if (!isPresent) {
          try {
            await userRepo.storeEmail(mailId: event.mailId);
            emit(LoginScreenLoadedState());
          } catch (err) {
            emit(AuthErrorState(err.toString()));
          }
        } else {
          emit(LoadHomeScreenState());
        }
      } catch (err) {
        emit(AuthErrorState(err.toString()));
      }
    });
  }
}
