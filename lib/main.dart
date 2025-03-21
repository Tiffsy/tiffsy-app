import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tiffsy_app/Helpers/internet_connectivity.dart';
import 'package:tiffsy_app/firebase_options.dart';
import 'package:tiffsy_app/screens/LoginScreen/repository/user_repo.dart';
import 'package:flutter/services.dart';
import 'package:tiffsy_app/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox("cart_box");
  await Hive.openBox("address_box");
  await Hive.openBox("customer_box");
  await Hive.openBox("coupon");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(
      RepositoryProvider(
        create: (context) => UserRepo(),
        child: const MyApp(),
      ),
    );
    DependencyInjection.init();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'Tiffsy',
      theme: getTheme(context),
    );
  }
}

ThemeData getTheme(BuildContext context) {
  return ThemeData(
    fontFamily: 'Gothic A1',
    textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Gothic A1'),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.red,
    ),
    datePickerTheme: const DatePickerThemeData(
        backgroundColor: Color(0xfffffcef),
        surfaceTintColor: Color(0xfffffcef),
        rangePickerSurfaceTintColor: Color(0xffCBFFB3),
        rangePickerBackgroundColor: Color(0xffCBFFB3),
        todayBorder: BorderSide(color: Color(0xffCBFFB3)),
        rangeSelectionBackgroundColor: Color(0xffCBFFB3)),
    appBarTheme: const AppBarTheme(
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Color(0xffffffff),
        shadowColor: Color(0xffffffff),
        surfaceTintColor: Color(0xffffffff)),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xcc121212),
      selectionHandleColor: Color(0xffffe5a3),
      selectionColor: Color(0x33ffbe1d),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xfffffcef),
      surfaceTintColor: Color(0xfffffcef),
      indicatorColor: Color(0xffffe5a3),
      iconTheme: MaterialStatePropertyAll(
        IconThemeData(
          color: Color(0xff323232),
        ),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => const Color(0xfffffcef),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xffffbe1d),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Color(0x66121212),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 24 / 16,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xffffbe1d),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(width: 1),
      ),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: Color(0xffFFBE1D)),
    iconTheme: const IconThemeData(color: Color(0xff323232)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffFFBE1D)),
    ),
    cardColor: const Color(0xffffffff),
    focusColor: const Color(0xffFFE5A3),
    primaryColor: const Color(0xFFFFFCEF),
    scaffoldBackgroundColor: const Color(0xFFFFFCEF),
    useMaterial3: true,
  );
}
