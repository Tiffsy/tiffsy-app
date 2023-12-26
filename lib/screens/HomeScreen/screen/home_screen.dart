import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';
import 'package:tiffsy_app/screens/LoginScreen/bloc/login_bloc.dart';
import 'package:tiffsy_app/screens/LoginScreen/screen/login_screen.dart';
import 'package:tiffsy_app/screens/ProfileScreen/screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    homeBloc.add(HomeInitialFetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeBloc.close();
    super.dispose();
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [],
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: ClipOval(
              child: Image.asset(
                'assets/images/logo/tiffsy.png',
                fit: BoxFit.cover,
              ),
            ), // TODO: Bio Pic
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.restaurant_menu),
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Menu',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.credit_card),
            icon: Icon(Icons.credit_card_outlined),
            label: 'Payments',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.food_bank),
            icon: Icon(Icons.food_bank_outlined),
            label: 'Subscription',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: <Widget>[
          menuPage(theme, homeBloc),
          Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Payments',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          ),
          Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Subscription',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ][currentPageIndex],
      ),
    );
  }
}

Widget menuPage(ThemeData theme, HomeBloc homeBloc) {
  return Builder(builder: (context) {
    var mediaQuery = MediaQuery.of(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is HomeFetchSuccessfulState) {
          final menuState = state;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                upgradeToDeluxCard(() {
                  // onTap for the upgrade to deluxe button.
                }),
                const SizedBox(height: 24),
                const Text(
                  // Today's Menu
                  "Today's Menu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: 0.15,
                    color: Color(0xff121212),
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  // list of menu cards
                  children: listOfMenuCards(menuState.menu, context, homeBloc),
                ),
              ],
            ),
          );
        }
        if (state is HomeErrorState) {
          return const SnackBar(
            content: Text("Error"),
          );
        }
        return const SizedBox();
      },
    );
  });
}

Widget upgradeToDeluxCard(Function upgradeCardOnTap) {
  return Builder(builder: (context) {
    return GestureDetector(
      onTap: () {
        upgradeCardOnTap();
      },
      child: SizedBox(
        width: (MediaQuery.sizeOf(context).width - 40),
        height: (MediaQuery.sizeOf(context).width - 40) * (154 / 372),
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/vectors/home_banner.svg',
              semanticsLabel: 'vector image',
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Image.asset(
                'assets/images/vectors/thali1 1.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  });
}

List<Widget> listOfMenuCards(
    List<MenuDataModel> menu, BuildContext context, HomeBloc homeBloc) {
  List<Widget> listOfMenuCards = [];
  for (var element in menu) {
    listOfMenuCards.addAll([
      customMenuCard(context, element, homeBloc),
      const SizedBox(height: 18),
      dashedDivider(context),
      const SizedBox(height: 16)
    ]);
  }
  return listOfMenuCards;
}

Widget customMenuCard(
    BuildContext context, MenuDataModel menuPage, HomeBloc homeBloc) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width - 20,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mealTypeTag(menuPage.type),
            const SizedBox(height: 12),
            SizedBox(
              width: (MediaQuery.sizeOf(context).width * 0.45) - 20,
              child: Row(
                children: [
                  Flexible(
                    child: mealCardBoldText(menuPage.title),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "₹${menuPage.price.toString()}",
              style: const TextStyle(
                color: Color(0xff121212),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              width: (MediaQuery.sizeOf(context).width * 0.45) - 20,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      menuPage.description,
                      style: const TextStyle(
                        color: Color(0xff121212),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        menuImage(homeBloc, menuPage, context)
      ],
    ),
  );
}

Widget menuImage(
    HomeBloc homeBloc, MenuDataModel menuPage, BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  return SizedBox(
    width: width * 0.35,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/images/vectors/thali_full.png',
          fit: BoxFit.contain,
          width: width * 0.3,
        ),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: (MediaQuery.sizeOf(context).width * 0.2) * 0.4,
            width: MediaQuery.sizeOf(context).width * 0.2,
            decoration: BoxDecoration(
              color: const Color(0xffcbffb3),
              border: Border.all(width: 1, color: const Color(0xff6aa64f)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                "Add",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Text mealCardBoldText(String text) {
  // Returns the string as a Text widget with the bold formatting mentioned in the
  // design.
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
  );
}

Widget mealTypeTag(String mealType) {
  // Returns the meal type string placed in the tag like container as mentioned in the
  // design.
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: const Color(0xffffbe1d),
    ),
    width: 76,
    height: 23,
    child: Center(
      child: Text(
        mealType,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 16 / 11,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

Widget dashedDivider(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  int count = (width / 16).floor();
  List<Widget> listOfDivider = [];
  for (count; count > 0; count--) {
    listOfDivider.add(
      const SizedBox(
        width: 8,
        child: Divider(
          color: Color(0x33121212),
          endIndent: 0,
          indent: 0,
          height: 1,
          thickness: 1,
        ),
      ),
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: listOfDivider,
  );
}

Widget subscriptionCard(String subscriptionType) {
  return Container(
    decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1EFFBE1D),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ]),
    height: 180,
    width: 142,
    child: const Column(
      children: [
        SizedBox(height: 47),
      ],
    ),
  );
}
