part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginContinueButtonClickedEvent extends LoginEvent{
}
class LoginContinueWithGoogleClickedEvent extends LoginEvent{
}
class GoogleSignInRequested extends LoginEvent {
}
class GoogleSignOutRequested extends LoginEvent{
}
class SignInWithGooglePressedEvent extends LoginEvent{

}
class SendOtpToPhoneEvent extends LoginEvent{
  final String phoneNumber;
  SendOtpToPhoneEvent({required this.phoneNumber});
}

class OnPhoneOtpSend extends LoginEvent{

  final String verificationId;
  final int? token;

  OnPhoneOtpSend({required this.verificationId, required this.token});
  
}

class VerifySentOtp extends LoginEvent{
  final String optCode;
  final String verificationId;

  VerifySentOtp({required this.optCode, required this.verificationId});
  
}

class OnPhoneAuthVerificationCompletedEvent extends LoginEvent{
  final AuthCredential credential;
  OnPhoneAuthVerificationCompletedEvent({required this.credential});
}

class OnPhoneAuthErrorEvent extends LoginEvent{
  final String error;
  OnPhoneAuthErrorEvent({required this.error});
}


class SendOtp extends LoginEvent {
  final String phoneNumber;
  const SendOtp({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}


class VerifyOtp extends LoginEvent{
  
  final String otp;
  final String verificationId;
  const VerifyOtp({required this.otp, required this.verificationId});

  @override
  List<Object> get props => [otp];
}
class SignInWithPhone extends LoginEvent{

  final PhoneAuthCredential credential;
  const SignInWithPhone({required this.credential});

  @override
  List<Object> get props => [credential];
}

class CheckPreviousPhoneEvent extends LoginEvent{
  final String phoneNumber;
  CheckPreviousPhoneEvent({required this.phoneNumber});
}

class CheckPreviousEmailEvent extends LoginEvent {
  final String mailId;
  CheckPreviousEmailEvent({required this.mailId});
}
                      
                     