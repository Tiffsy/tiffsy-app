import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:tiffsy_app/Helpers/loading_animation.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/screens/AddAddressScreen/screen/add_address_screen.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart';
import 'package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/cart_page.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/menu_page.dart';
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
    HomeBloc homeBloc = HomeBloc();
    if (menuState.menu.isEmpty) {
      homeBloc.add(HomeInitialFetchEvent(isCached: false));
    } else {
      homeBloc.add(HomeInitialFetchEvent(isCached: true));
    }
    return BlocProvider(
      create: (context) => homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeErrorState) {
            const SnackBar(
              content: Text("Error"),
            );
          }
        },
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
                              AddAddressScreen(onAdd: () {}),
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
                        child: (user.photoURL != null)
                            ? Image.network(
                                '${user.photoURL}',
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 42,
                                width: 42,
                                color: Colors.amber[200],
                                child: Center(
                                  child: Text(
                                    Hive.box('customer_box')
                                        .get('cst_name', defaultValue: "0")[0]
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
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
                    selectedIcon: NavigationBarCartItem(isSelected: true),
                    icon: NavigationBarCartItem(isSelected: false),
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
                  MenuScreenHomePage(homeBloc: homeBloc),
                  CartScreenHomePage(homeBloc: homeBloc),
                  SubscriptionHomePageScreen()
                ][currentPageIndex],
              ),
            );
          } else if (state is HomeFetchSuccessfulIsCachedState) {
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
                              AddAddressScreen(onAdd: () {}),
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
                        child: (user.photoURL != null)
                            ? Image.network(
                                '${user.photoURL}',
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 42,
                                width: 42,
                                color: Colors.amber[200],
                                child: Center(
                                  child: Text(
                                    Hive.box('customer_box')
                                        .get('cst_name', defaultValue: "0")[0]
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
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
                    selectedIcon: NavigationBarCartItem(isSelected: true),
                    icon: NavigationBarCartItem(isSelected: false),
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
                  MenuScreenHomePage(homeBloc: homeBloc),
                  CartScreenHomePage(homeBloc: homeBloc),
                  SubscriptionHomePageScreen()
                ][currentPageIndex],
              ),
            );
          } else {
            print(state.toString());
            return Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                leadingWidth: 60,
                leading: const Icon(
                  Icons.location_on,
                  size: 36,
                  color: Color(0xffffbe1d),
                ),
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
                    selectedIcon: NavigationBarCartItem(isSelected: true),
                    icon: NavigationBarCartItem(isSelected: false),
                    label: 'Cart',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.food_bank),
                    icon: Icon(Icons.food_bank_outlined),
                    label: 'Subscription',
                  )
                ],
              ),
              body: Center(
                child: LoadingAnimation.errorAnimation(
                    context, "Something went wrong"),
              ),
            );
          }
        },
      ),
    );
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
          height: 24 / 16,
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

class NavigationBarCartItem extends StatefulWidget {
  const NavigationBarCartItem({super.key, required this.isSelected});
  final bool isSelected;

  @override
  State<NavigationBarCartItem> createState() => _NavigationBarCartItemState();
}

class _NavigationBarCartItemState extends State<NavigationBarCartItem> {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomePageCartQuantityChangeState) {
            setState(() {
              count = Hive.box("cart_box").get("cart", defaultValue: []).length;
            });
            print(count);
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                  height: 32,
                  child: widget.isSelected
                      ? const Icon(Icons.shopping_cart)
                      : const Icon(Icons.shopping_cart_outlined)),
              (count > 0)
                  ? Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Center(
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            height: 1,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}
