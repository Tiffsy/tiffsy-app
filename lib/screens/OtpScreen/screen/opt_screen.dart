import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tiffsy_app/repositories/user_repository.dart';
import 'package:tiffsy_app/screens/LoginScreen/bloc/login_bloc.dart';
import 'package:tiffsy_app/screens/PersonalDetailsScreen/screen/personalDetails_screen.dart';


class OtpScreen extends StatefulWidget {

  final String verificationId;
  final String phoneNumber;
  const OtpScreen({Key? key, required this.verificationId, required this.phoneNumber}): super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider(
        create: (context) => LoginBloc(userRepository: RepositoryProvider.of(context)),
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "OTP Verification",
                textAlign: Platform.isIOS ? TextAlign.left : TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Color(0xffFAFAFA),
            ),
            backgroundColor: Color(0xffFAFAFA),
            body: content(verificationId: widget.verificationId, phoneNumber: widget.phoneNumber,)),
      ),
    );
  }
}

class content extends StatefulWidget {

  final String verificationId;
  final String phoneNumber;
  const content({Key? key, required this.verificationId, required this.phoneNumber}): super(key: key);

  @override
  State<content> createState() => _contentState();
}

class _contentState extends State<content> {
  int secondsRemaining = 25;
  bool enableResend = false;
  late Timer timer;
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 48,
    height: 48,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFFCDCDCD)),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  late final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Color(0xFFCDCDCD)),
    borderRadius: BorderRadius.circular(8),
    color: Color(0xffFAFAFA),
  );

  late final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: Color.fromARGB(255, 244, 217, 148),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {

    var _mediaQuery = MediaQuery.of(context);
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if(state is AuthLoggedInState){
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()));
        }
        else if (state is AuthErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 10),
              )
          );
        }
      },
      builder: (context, state) {

         if(state is AuthLoadingState){
            return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: _mediaQuery.size.height * 1.0,
            width: _mediaQuery.size.width * 1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity, height: 196),
                const Text(
                  "We have sent a verification code to",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 21,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(width: double.infinity, height: 20),
                Text(
                  '+91-${widget.phoneNumber}',
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 21,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const SizedBox(width: double.infinity, height: 20),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  length: 6,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) {
                    BlocProvider.of<LoginBloc>(context).add(VerifyOtp(otp: pin.toString(), verificationId: widget.verificationId));
                  },
                  controller: otpController,
                ),
                const SizedBox(width: double.infinity, height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't get the OTP?",
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 21,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Visibility(
                        visible: enableResend,
                        child: TextButton(
                            onPressed: () => {_resendCode()},
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                  color: Color(0xFF121212),
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0),
                            ))),
                    Visibility(
                      visible: !enableResend,
                      child: Text(
                        'Resend SMS in $secondsRemaining',
                        style: const TextStyle(
                            color: Color(0xFF121212),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
