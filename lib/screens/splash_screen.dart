import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: ));
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
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          child: Expanded(
            child: Lottie.asset('assets/splashScreen.json', fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
