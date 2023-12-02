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
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
     Future.delayed(const Duration(milliseconds: 2325), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: content(),
    );
  }
  
  Widget content(){
    return Column(
      children: [
        Expanded(
          child: Lottie.asset('assets/splashScreen.json',
          width: (MediaQuery.of(context).size.width),
          height:(MediaQuery.of(context).size.height),
          fit: BoxFit.fill
          ),
        ),
      ],
    );
  }
}