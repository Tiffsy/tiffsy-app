import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tiffsy_app/firebase_options.dart';
import 'package:tiffsy_app/screens/AddAddressScreen/screen/add_address_screen.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/screen/address_book_screen.dart';
import 'package:tiffsy_app/screens/BillingSumaryScreen/screen/billing_summary_screen.dart';
import 'package:tiffsy_app/screens/CartScreen/screen/cart_screen.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/HowItWorksScreen/bloc/how_it_works_bloc.dart';
import 'package:tiffsy_app/screens/HowItWorksScreen/screen/how_it_works_screen.dart';
import 'package:tiffsy_app/screens/LoginScreen/bloc/login_bloc.dart';
import 'package:tiffsy_app/screens/LoginScreen/repository/user_repo.dart';
import 'package:tiffsy_app/screens/LoginScreen/screen/login_screen.dart';
import 'package:tiffsy_app/screens/OrderHistoryScreen/bloc/order_history_bloc.dart';
import 'package:tiffsy_app/screens/OrderHistoryScreen/screen/order_history_screen.dart';
import 'package:tiffsy_app/screens/OtpScreen/screen/opt_screen.dart';
import 'package:tiffsy_app/screens/PersonalDetailsScreen/screen/personalDetails_screen.dart';
import 'package:tiffsy_app/screens/ProfileScreen/bloc/profile_bloc.dart';
import 'package:tiffsy_app/screens/ProfileScreen/screen/profile_screen.dart';
import 'package:tiffsy_app/screens/PaymentCheckoutScreen/screen/payment_checkout_screen.dart';
import 'package:tiffsy_app/screens/SubscriptionScreen/screen/subscription_screen.dart';

import 'package:tiffsy_app/screens/splash_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox("cart_box");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      RepositoryProvider(
        create: (context) => UserRepo(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'Tiffsy',
      theme: getTheme(),
    );
  }
}

ThemeData getTheme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      titleSpacing: 0,
      backgroundColor: Color(0xffffffff),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xcc121212),
      selectionHandleColor: Color(0xffffe5a3),
      selectionColor: Color(0x33ffbe1d),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xfffffcef),
      surfaceTintColor: Color(0xfffffcef),
      indicatorColor: Color(0xffffe5a3),
      iconTheme:
          MaterialStatePropertyAll(IconThemeData(color: Color(0xff323232))),
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
