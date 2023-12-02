import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiffsy_app/firebase_options.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/LoginScreen/screen/login_screen.dart';
import 'package:tiffsy_app/screens/OtpScreen/screen/opt_screen.dart';
import 'package:tiffsy_app/screens/ProfileScreen/screen/profile_screen.dart';
import 'package:tiffsy_app/screens/splash_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
      title: 'Tiffsy',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(buttonColor: const Color(0xffFFBE1D)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFFBE1D)),
        ),
        cardColor: const Color(0xffffffff),
        focusColor: const Color(0xffFFE5A3),
        primaryColor: Color(0xFFFFFCEF),
        scaffoldBackgroundColor: const Color(0xFFFFFCEF),
        useMaterial3: true,
      ),
    );
  }
}
