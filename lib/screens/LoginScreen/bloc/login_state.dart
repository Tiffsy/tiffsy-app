part of 'login_bloc.dart';

abstract class LoginState extends Equatable{
  @override
  List<Object> get props => [];
}

abstract class LoginActionState extends LoginState{
}
class UnAuthenticated extends LoginActionState{
}
class Authenticated extends LoginActionState{
}
class AuthLoadingState extends LoginState{
}

class LoginScreenInitialState extends LoginState{

}

class OTPScreenInitialState extends LoginState{

}
class LoginScreenLoadedState extends LoginState{

}

class LoadHomeScreenState extends LoginState{

}
class AuthCodeSentSate extends LoginActionState{
  final String verificationId;
  final String phoneNumber;
  AuthCodeSentSate({required this.verificationId, required this.phoneNumber});
}

class CodeSentSuccessState extends LoginActionState{
  final String verificationId;
  CodeSentSuccessState({required this.verificationId});
}

class AuthCodeVerifiedState extends LoginActionState{
}

class AuthLoggedInState extends LoginActionState{
  final User firebaseUser;
  AuthLoggedInState(this.firebaseUser);
}
class AuthPreRegisteredSate extends LoginActionState{ 
}
class AuthLoggedOut extends LoginActionState{
}

class AuthErrorState extends LoginActionState{
  final String error;
  AuthErrorState(this.error);
}

class PhoneAuthCodeSentSuccess extends LoginState{
  final String verificationId;
  PhoneAuthCodeSentSuccess({required this.verificationId});
}