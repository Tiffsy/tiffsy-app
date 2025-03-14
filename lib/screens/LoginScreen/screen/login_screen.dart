import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/main.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/LoginScreen/bloc/login_bloc.dart';
import 'package:tiffsy_app/screens/OtpScreen/screen/opt_screen.dart';
import '../../PersonalDetailsScreen/screen/personalDetails_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     systemNavigationBarColor: Color(0xfffafafa),
    //     statusBarColor: Color(0xffF2B620),
    //   ),
    // );
    Box customerBox = Hive.box("customer_box");
    Box addressBox = Hive.box("address_box");
    Box cartBox = Hive.box("cart_box");
    addressBox.clear();
    customerBox.clear();
    cartBox.clear();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xfffafafa),
        statusBarColor: Color(0xffF2B620),
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: content(),
    );
  }
}

class content extends StatefulWidget {
  const content({super.key});
  @override
  State<content> createState() => _contentState();
}

class _contentState extends State<content> {
  final GlobalKey _tooltipKey = GlobalKey();
  TextEditingController countryCode = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  LoginBloc loginBloc = LoginBloc(LoginScreenInitialState());
  bool phoneIsExpanded = false;

  @override
  void initState() {
    super.initState();
    countryCode.text = "+91";
  }

  @override
  void dispose() {
    countryCode.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showTooltip() {
    final dynamic tooltip = _tooltipKey.currentState;
    tooltip.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is LoginScreenLoadedState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              SlideTransitionRouter.toNextPage(const PersonalDetailsScreen(
                isPhoneAuth: false,
                phoneNumber: "0000000000",
              )));
        } else if (state is PhoneAuthCodeSentSuccess) {
          Navigator.push(
              context,
              SlideTransitionRouter.toNextPage(OtpScreen(
                verificationId: state.verificationId,
                phoneNumber: phoneController.text,
              )));
        } else if (state is LoadHomeScreenState) {
          Navigator.pushAndRemoveUntil(
            context,
            SlideTransitionRouter.toNextPage(HomeScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return Center(
            child: Container(
              child: Lottie.asset('assets/Tiffsy1.json'),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: _mediaQuery.size.height * 0.450,
                  decoration: const BoxDecoration(
                    color: Color(0xffF2B620),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/vectors/foodpic.svg',
                      semanticsLabel: 'vector image',
                    ),
                  ),
                ),
                Container(
                  height: _mediaQuery.size.height * 0.550,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                    color: Color(0xffFAFAFA),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: _mediaQuery.size.height * 0.04),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Divider(
                                  thickness: 1,
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  indent: 20,
                                  endIndent: 22)),
                          Text(
                            'Log in or sign up',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 194, 194, 194),
                              indent: 22,
                              endIndent: 20,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: _mediaQuery.size.height * 0.045,
                        width: _mediaQuery.size.width * 0.9,
                        child: OutlinedButton(
                          onPressed: () =>
                              {loginBloc.add(SignInWithGooglePressedEvent())},
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/vectors/Google_icon.svg',
                                semanticsLabel: 'vector image',
                                width:
                                    MediaQuery.of(context).size.width * 0.038,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.038,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                    height: 0.10),
                                'Continue with Google Account',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 194, 194, 194),
                              indent: 20,
                              endIndent: 20,
                            ),
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 194, 194, 194),
                              indent: 20,
                              endIndent: 20,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: _mediaQuery.size.height * 0.060,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              const Text(
                                "IND",
                                style: TextStyle(
                                  color: Color(0xFF0F1728),
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.phone,
                                  controller: countryCode,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                              const SizedBox(width: 0.1),
                              Flexible(
                                flex: 5,
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Phone Number',
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto'),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                              Tooltip(
                                key: _tooltipKey,
                                message: 'Enter your 10 digit phone number',
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline_sharp),
                                  onPressed: () => {showTooltip()},
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: _mediaQuery.size.height * 0.045,
                        width: _mediaQuery.size.width * 0.9,
                        child: OutlinedButton(
                          onPressed: () {
                            if (phoneController.text.length == 10 &&
                                phoneController.text.isNum) {
                              String phoneNumber = "+91${phoneController.text}";
                              loginBloc.add(SendOtpToPhoneEvent(
                                  phoneNumber: phoneNumber));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Invalid Phone Number!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xffFAFAFA)),
                            backgroundColor: const Color(0xffF2B620),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                                height: 0.08,
                                color: Colors.black),
                            'Continue',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}