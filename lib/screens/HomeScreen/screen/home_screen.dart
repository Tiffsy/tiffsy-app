import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/screens/AddAddressScreen/screen/add_address_screen.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart';
import 'package:tiffsy_app/screens/CartScreen/screen/cart_screen.dart';
import 'package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';
import 'package:tiffsy_app/screens/ProfileScreen/screen/profile_screen.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/screen/subscription_home_page_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

// Home bloc consumer
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xfffffcef)));

    super.initState();
  }

  @override
  void dispose() {
    //homeBloc.close();
    super.dispose();
  }

  int currentPageIndex = 0;
  Box cartBox = Hive.box("cart_box");
  Box addressBox = Hive.box("address_box");
  AddressDataModel? defaultAddress;

  HomeFetchSuccessfulState menuState = HomeFetchSuccessfulState(menu: const []);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    HomeBloc homeBloc = HomeBloc();

    if (menuState.menu.isEmpty) {
      homeBloc.add(HomeInitialFetchEvent(isCached: false));
    } else {
      homeBloc.add(HomeInitialFetchEvent(isCached: true));
    }
    cartBox.put("addr", "A1, Leiure Town");
    return BlocProvider(
      create: (context) => homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return Container(
              color: const Color(0xffffffff),
              child: Center(
                child: Lottie.asset('assets/home_loader.json'),
              ),
            );
          } else if (state is HomeFetchSuccessfulState) {
            menuState = state;
            Map? temp = addressBox.get("default_address");
            Map<String, dynamic>? tempTwo;
            if (temp != null) {
              tempTwo =
                  temp.map((key, value) => MapEntry(key.toString(), value));
            }
            defaultAddress = AddressDataModel.fromJsonAllowNull(
              tempTwo,
            );
          } else if (state is HomeErrorState) {
            return const SnackBar(
              content: Text("Error"),
            );
          } else if (state is HomePageCartQuantityChangeState) {
          } else if (state is HomeFetchSuccessfulIsCachedState) {}
          return Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
              leadingWidth: 60,
              leading: const Icon(
                Icons.location_on,
                size: 36,
                color: Color(0xffffbe1d),
              ),
              title: GestureDetector(
                onTap: () async {
                  (defaultAddress == null)
                      ? Navigator.push(
                          context,
                          SlideTransitionRouter.toNextPage(
                            const AddAddressScreen(),
                          ),
                        )
                      : await showAddressBottomSheet(homeBloc);
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4 + 32,
                  child: (defaultAddress == null)
                      ? const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add Address",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                height: 24 / 16,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width *
                                              0.4),
                                  child: Text(
                                    defaultAddress!.houseNum,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF121212),
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      height: 24 / 16,
                                      letterSpacing: 0.15,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 24,
                                ),
                              ],
                            ),
                            Text(
                              (defaultAddress != null)
                                  ? defaultAddress!.addrLine
                                  : "",
                              style: const TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                              ),
                            )
                          ],
                        ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlideTransitionRouter.toNextPage(
                          const ProfileScreen(),
                        ),
                      );
                    },
                    icon: ClipOval(
                      child: Image.asset(
                        'assets/images/logo/tiffsy.png',
                        fit: BoxFit.contain,
                      ),
                    ), // TODO: Bio Pic
                  ),
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
                  selectedIcon: Icon(Icons.shopping_cart),
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Cart',
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
                cartPage(theme, homeBloc, context),
                SubscriptionHomePageScreen()
              ][currentPageIndex],
            ),
          );
        },
      ),
    );
  }

  Widget menuPage(ThemeData theme, HomeBloc homeBloc) {
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
      },
    );
  }

  Widget cartPage(ThemeData theme, HomeBloc homeBloc, BuildContext context) {
    List<Widget> listOfCards = listOfCartCards(context, homeBloc);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          upgradeToDeluxCard(() {
            // onTap for the upgrade to deluxe button.
          }),
          const SizedBox(height: 24),
          const Text(
            "Your Cart",
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
            children: listOfCards,
          ),
          emptyCartMessageBox(
            context,
            listOfCards.isEmpty
                ? "Add items from the menu."
                : "Choose delivery address on top",
          ),
          const SizedBox(height: 10),
          listOfCards.isEmpty
              ? const SizedBox()
              : orderNowButton(() {
                  Navigator.push(context,
                      SlideTransitionRouter.toNextPage(const CartScreen()));
                }),
          const SizedBox(height: 10),
        ],
      ),
    );
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
    Map<String, List<MenuDataModel>> temp = {};

    for (var element in menu) {
      temp[element.mealTime] = (temp[element.mealTime] ?? []) + [element];
    }
    temp.forEach((key, value) {
      value.sort((a, b) => a.price.compareTo(b.price));
    });

    List<String> mealOrder = ["breakfast", "lunch", "dinner"];

    for (var key in mealOrder) {
      if (temp[key] != null) {
        listOfMenuCards.addAll([
          customMenuCard(context, temp[key]![0], homeBloc),
          const SizedBox(height: 18),
          dashedDivider(context),
          const SizedBox(height: 16)
        ]);
      }
    }

    return listOfMenuCards;
  }

  List<Widget> listOfCartCards(BuildContext context, HomeBloc homeBloc) {
    List<Widget> listOfMenuCards = [];
    List cartItems = cartBox.get("cart", defaultValue: []);

    for (var element in cartItems) {
      listOfMenuCards.addAll([
        customCartCard(context, element, homeBloc),
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
              mealTimeTag(menuPage.mealTime),
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
                "Starting from ₹${menuPage.price.toString()}/-",
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
          menuImage(menuPage.mealTime, homeBloc, menuPage, context)
        ],
      ),
    );
  }

  Widget customCartCard(BuildContext context, Map menuPage, HomeBloc homeBloc) {
    Map menu = cartBox.get('menu');
    Map menuObject = menu[menuPage["mealTime"]][menuPage["mealType"]];
    Map<String, dynamic> menuObjectCasted = {};
    menuObject.forEach((key, value) {
      menuObjectCasted[key.toString()] = value;
    });
    MenuDataModel menuData = MenuDataModel.fromJson(menuObjectCasted);
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
              SizedBox(
                width: 162,
                child: Row(
                  children: [
                    mealTimeTag(menuData.mealTime),
                    const SizedBox(width: 10),
                    mealTypeTag(menuData.mealType),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: (MediaQuery.sizeOf(context).width * 0.45) - 20,
                child: Flexible(
                  child: Row(
                    children: [
                      mealCardBoldText(menuData.title),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${menuData.price.toString()}/-",
                style: const TextStyle(
                  color: Color(0xff121212),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 20 / 14,
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
                        menuData.description,
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
          cartImage(homeBloc, menuData, context)
        ],
      ),
    );
  }

  Widget menuImage(String menuTime, HomeBloc homeBloc, MenuDataModel menuPage,
      BuildContext context) {
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
            onTap: () async {
              Map<String, Map<String, Map>> menu = cartBox.get('menu');
              showOptionsOfMeal(menu[menuTime]!, menuTime, homeBloc, context);
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: (MediaQuery.sizeOf(context).width * 0.2) * 0.4,
              width: (MediaQuery.sizeOf(context).width * 0.2) < 90
                  ? 90
                  : (MediaQuery.sizeOf(context).width * 0.2),
              decoration: BoxDecoration(
                color: const Color(0xffcbffb3),
                border: Border.all(width: 1, color: const Color(0xff6aa64f)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Color(0xFF6AA64F),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0.09,
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

  Widget cartImage(
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
            onTap: () {
              homeBloc.add(
                HomePageRemoveFromCartEvent(
                  mealTime: menuPage.mealTime,
                  mealType: menuPage.mealType,
                ),
              );
              setState(() {});
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: (MediaQuery.sizeOf(context).width * 0.2) * 0.4,
              width: (MediaQuery.sizeOf(context).width * 0.2) < 90
                  ? 90
                  : (MediaQuery.sizeOf(context).width * 0.2),
              decoration: BoxDecoration(
                color: const Color(0xffFFDDDD),
                border: Border.all(width: 1, color: const Color(0xffF84545)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  "Remove",
                  style: TextStyle(
                    color: Color(0xFFF84545),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0.09,
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

  Future<dynamic> showOptionsOfMeal(
    Map<String, Map> menuOptions,
    String menuTime,
    HomeBloc homeBloc,
    BuildContext context,
  ) {
    List<String> listOfMealTypes = menuOptions.keys.toList();
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height * 0.3,
          ),
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Text(
                  "Choose $menuTime Type",
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: 0.15,
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: listOfButtons(
                        menuTime, listOfMealTypes, homeBloc, menuOptions),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> listOfButtons(String mealTime, List<String> listOfMealTypes,
      HomeBloc homeBloc, Map<String, Map> menuOptions) {
    List<Widget> listOfMealOptions = [];
    for (var element in listOfMealTypes) {
      listOfMealOptions.add(
        OutlinedButton(
          onPressed: () {
            homeBloc.add(
                HomePageAddTocartEvent(mealTime: mealTime, mealType: element));
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Text(element),
              const Spacer(),
              Text(menuOptions[element]?["price"].toString() ?? "0"),
            ],
          ),
        ),
      );
    }
    return listOfMealOptions;
  }

  Future<dynamic> showAddressBottomSheet(HomeBloc homeBloc) {
    Box addressBox = Hive.box("address_box");
    List listOfAddress = addressBox.get("list_of_address");
    List<Widget> listOfAddressCards = [];
    for (Map element in listOfAddress) {
      Map<String, dynamic> addressData =
          element.map((key, value) => MapEntry(key.toString(), value));
      listOfAddressCards
          .add(addressCard(AddressDataModel.fromJson(addressData), context));
    }
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.3,
          ),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24, bottom: 20, top: 20),
                child: Text(
                  "Choose Your Address:",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      <Widget>[const SizedBox(width: 20)] + listOfAddressCards,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget addressCard(AddressDataModel address, BuildContext context) {
    IconData addressTypeIcon = Icons.home;
    if (address.addrType == "Work") {
      addressTypeIcon = Icons.work;
    } else if (address.addrType == "Home") {
      addressTypeIcon = Icons.home;
    } else {
      addressTypeIcon = Icons.language_rounded;
    }
    Widget addressTypeData = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          addressTypeIcon,
          size: 24,
          color: const Color(0xffffbe1d),
        ),
        const SizedBox(width: 12),
        Text(
          address.addrType,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xff121212),
            height: 1.5,
          ),
        ),
      ],
    );

    return InkWell(
      onTap: () {
        Hive.box("address_box").put("default_address", address.toJson());
        setState(() {
          defaultAddress = address;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          constraints: const BoxConstraints(minWidth: 200),
          decoration: ShapeDecoration(
            color: const Color(0xFFFFFCEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addressTypeData,
                const SizedBox(height: 8),
                mealCardBoldText(address.houseNum),
                mealCardBoldText(address.addrLine),
                mealCardBoldText("${address.city}, ${address.state}"),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// These funtions are only used for styling and decoration, No logic exists here
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

Widget mealTimeTag(String mealTime) {
  // Returns the meal time string placed in the tag like container as mentioned in the
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
        toSentenceCase(mealTime),
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

Widget mealTypeTag(String mealType) {
  return Container(
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFFFBE1D)),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    width: 76,
    height: 23,
    child: Center(
      child: Text(
        toSentenceCase(mealType),
        style: const TextStyle(
          color: Color(0xFFFFBE1D),
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

Widget orderNowButton(VoidCallback onpress) {
  Widget buttonText = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      Text(
        "Order Now",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xff121212),
          height: 1.5,
        ),
      ),
      Spacer()
    ],
  );
  return InkWell(
    onTap: () {
      onpress();
    },
    child: Container(
      constraints: const BoxConstraints(maxHeight: 40),
      decoration: BoxDecoration(
        color: const Color(0xffffbe1d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 24, 10),
        child: buttonText,
      ),
    ),
  );
}

Widget emptyCartMessageBox(BuildContext context, String message) {
  return Container(
    width: MediaQuery.sizeOf(context).width - 40,
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFFFBE1D)),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    child: Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF121212),
          fontSize: 12,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          height: 0.11,
          letterSpacing: 0.50,
        ),
      ),
    ),
  );
}

String toSentenceCase(String input) {
  if (input.isEmpty) return '';
  return '${input[0].toUpperCase()}${input.substring(1).toLowerCase()}';
}

//Widget navigationBarCartItem(bool isSelected, int count) {}
