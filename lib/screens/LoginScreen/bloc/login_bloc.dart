import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pinput/pinput.dart';
import 'package:tiffsy_app/repositories/user_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc({required this.userRepository}) : super(UnAuthenticated()){
    on<GoogleSignInRequested>(_onGoogleSignInPressed);
    on<GoogleSignOutRequested>(_onGoogleSignOutPressed);
    on<SendOtp>(_sendOtpPressed);
    on<VerifyOtp>(_verifyOtp);
    on<SignInWithPhone>(_signInWithOtp);
  }

  final UserRepository userRepository;
  String? _verificationId;

  FutureOr<void> _onGoogleSignInPressed(GoogleSignInRequested event, Emitter<LoginState> emit) async{
    final response = await userRepository.signInWithGoogle();
    if(response != null){
      emit(Authenticated());
    }
  }

  FutureOr<void> _onGoogleSignOutPressed(GoogleSignOutRequested event, Emitter<LoginState> emit) {
    userRepository.handleSignOut();
    emit(UnAuthenticated());
  }


  FutureOr<void> _sendOtpPressed(SendOtp event, Emitter<LoginState> emit) async {

    emit(AuthLoadingState());
    final phoneNumber = event.phoneNumber;
    Completer<void> completer = Completer<void>(); // Create a Completer

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        print('\x1B[33mVerification completed verf\x1B[0m' );
        add(SignInWithPhone(credential: phoneAuthCredential));
        completer.complete();
      }, 
      verificationFailed: (error){
        emit(AuthErrorState(error.message.toString()));
      }, 
      codeSent: (verificationId, forceResendingToken) {
        this._verificationId = verificationId;
        print('\x1B[33m${_verificationId}\x1B[0m');
        print('\x1B[33mVerification completfasfdaed\x1B[0m');
        emit(AuthCodeSentSate(verificationId: verificationId, phoneNumber: phoneNumber));
      }, 
      codeAutoRetrievalTimeout: (verificationId){
        _verificationId = verificationId;
      }
    );

    await completer.future; // Await the completion of the Future
    print('\x1B[33mThis is yellow text\x1B[0m');
    // emit(AuthCodeSentSate());
  }

  FutureOr<void> _verifyOtp(VerifyOtp event, Emitter<LoginState> emit) async {
    
    Completer<void> completer = Completer<void>();
    try{
      final otp = event.otp;
      this._verificationId = event.verificationId;
      
      print("response otp: " + otp);
      emit(AuthLoadingState());
      print('\x1B[33m${_verificationId}\x1B[0m');
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: otp);
      add(SignInWithPhone(credential: credential));
    } catch (error){
      emit(AuthErrorState(error.toString()));
    }
    print('\x1B[33m_verify otp fadsfdas\x1B[0m');
    completer.complete();
    await completer.future; 
    print('\x1B[33m_verify otp\x1B[0m');

  }

  FutureOr<void> _signInWithOtp(SignInWithPhone event, Emitter<LoginState> emit) async {
    
    final credential = event.credential;

    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if(userCredential.user != null){
        print('\x1B[33mUser credential\x1B[0m');

        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (ex){
        emit(AuthErrorState(ex.message.toString()));
    }

  }

}
