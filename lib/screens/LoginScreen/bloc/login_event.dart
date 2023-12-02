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


// BlocConsumer<LoginBloc, LoginState>(
//                     listener: (context, state) {

//                       if(state is AuthLoggedInState){
//                         Navigator.popUntil(context, (route) => route.isFirst);
//                         Navigator.pushReplacement(context,
//                             MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()));
//                       }
//                       else if (state is AuthErrorState){
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text(state.error),
//                               backgroundColor: Colors.red,
//                               duration: const Duration(microseconds: 2000),
//                             )
//                         );
//                       }

//                     },
//                     builder: (context, state) {
                      
                     