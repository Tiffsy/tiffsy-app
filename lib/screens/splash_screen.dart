import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/LoginScreen/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    Future.delayed(const Duration(milliseconds: 2325), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: MediaQuery.sizeOf(context).height,
    //   width: MediaQuery.sizeOf(context).width,
    //   decoration: const BoxDecoration(
    //     color: Colors.white,
    //   ),
    //   child: Center(
    //       child:
    //           Lottie.asset("assets/splashScreen.json", fit: BoxFit.fitHeight)),
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: Lottie.asset('assets/splashScreen.json', fit: BoxFit.fill),
      ),
    );
  }
}
