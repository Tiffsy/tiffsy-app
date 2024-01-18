import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';

class MenuScreenHomePage extends StatefulWidget {
  const MenuScreenHomePage({super.key, required this.homeBloc});
  final HomeBloc homeBloc;

  @override
  State<MenuScreenHomePage> createState() => _MenuScreenHomePageState();
}

class _MenuScreenHomePageState extends State<MenuScreenHomePage> {
  HomeFetchSuccessfulState menuState = HomeFetchSuccessfulState(menu: const []);
  Box cartBox = Hive.box("cart_box");
  bool orderNowButtonIsExpanded = false;
  bool subscriptionButtonIsExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is HomeFetchSuccessfulState) {
          menuState = state;
        } else if (state is HomeFetchSuccessfulIsCachedState) {}
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              orderNowExpandableButton(),
              const SizedBox(height: 12),
              subscriptionExpandableButton(),
              const SizedBox(height: 12),
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
                children:
                    listOfMenuCards(menuState.menu, context, widget.homeBloc) +
                        [const SizedBox(height: 12)],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget orderNowExpandableButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          orderNowButtonIsExpanded = !orderNowButtonIsExpanded;
          subscriptionButtonIsExpanded = false;
        });
      },
      child: AnimatedContainer(
        height: orderNowButtonIsExpanded ? 160 : 42,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(orderNowButtonIsExpanded ? 16 : 8),
            side: BorderSide(
                width: orderNowButtonIsExpanded ? 1.5 : 1,
                color: const Color(0xffFFBE1D)),
          ),
          color: orderNowButtonIsExpanded
              ? const Color(0xfffffcef)
              : const Color(0xffffffff),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Order Now!",
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 20 / 16,
                  letterSpacing: 0.10,
                ),
              ),
              const SizedBox(height: 16),
              rowOfOrderNowCards(context, widget.homeBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget subscriptionExpandableButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          subscriptionButtonIsExpanded = !subscriptionButtonIsExpanded;
          orderNowButtonIsExpanded = false;
        });
      },
      child: AnimatedContainer(
        height: subscriptionButtonIsExpanded ? 160 : 42,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(subscriptionButtonIsExpanded ? 16 : 8),
            side: BorderSide(
                width: subscriptionButtonIsExpanded ? 1.5 : 1,
                color: const Color(0xffFFBE1D)),
          ),
          color: subscriptionButtonIsExpanded
              ? const Color(0xfffffcef)
              : const Color(0xffffbe1d),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Get a Subscription!",
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 20 / 16,
                  letterSpacing: 0.10,
                ),
              ),
              const SizedBox(height: 16),
              rowOfSubscriptionCards(context, widget.homeBloc),
            ],
          ),
        ),
      ),
    );
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
                width: (MediaQuery.sizeOf(context).width * 0.40) - 20,
                child: Row(
                  children: [
                    Flexible(
                      child: mealCardBoldText(menuPage.title),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              SizedBox(
                width: (MediaQuery.sizeOf(context).width * 0.55) - 20,
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
        ],
      ),
    );
  }

  Widget rowOfOrderNowCards(BuildContext context, HomeBloc homeBloc) {
    return SizedBox(
      //width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          orderNowButtons(
              context,
              "assets/images/vectors/home_screen/Brunch.svg",
              "breakfast",
              homeBloc),
          orderNowButtons(context,
              "assets/images/vectors/home_screen/Ramen.svg", "lunch", homeBloc),
          orderNowButtons(
              context,
              "assets/images/vectors/home_screen/Spaghetti.svg",
              "dinner",
              homeBloc),
        ],
      ),
    );
  }

  Widget rowOfSubscriptionCards(BuildContext context, HomeBloc homeBloc) {
    return SizedBox(
      //width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          orderSubscriptionButtons(
              context,
              "assets/images/vectors/home_screen/Brunch.svg",
              "breakfast",
              homeBloc),
          orderSubscriptionButtons(context,
              "assets/images/vectors/home_screen/Ramen.svg", "lunch", homeBloc),
          orderSubscriptionButtons(
              context,
              "assets/images/vectors/home_screen/Spaghetti.svg",
              "dinner",
              homeBloc),
        ],
      ),
    );
  }

  Widget orderNowButtons(BuildContext context, String imageAsset,
      String menuTime, HomeBloc homeBloc) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0x00000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                height: 80,
                width: (MediaQuery.sizeOf(context).width - 72) / 3,
                child: Column(
                  children: [
                    const SizedBox(height: 7),
                    SizedBox(height: 41, child: SvgPicture.asset(imageAsset)),
                    Text(
                      toSentenceCase(menuTime),
                      style: const TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                        letterSpacing: 0.50,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
          InkWell(
            onTap: () async {
              Map<String, Map<String, Map>> menu = cartBox.get('menu');
              showOptionsOfMeal(menu[menuTime]!, menuTime, homeBloc, context);
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 76,
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xffcbffb3),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF6AA64F)),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Add',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6AA64F),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      letterSpacing: 0.50,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget orderSubscriptionButtons(BuildContext context, String imageAsset,
      String menuTime, HomeBloc homeBloc) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0x00000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                height: 80,
                width: (MediaQuery.sizeOf(context).width - 72) / 3,
                child: Column(
                  children: [
                    const SizedBox(height: 7),
                    SizedBox(height: 41, child: SvgPicture.asset(imageAsset)),
                    Text(
                      toSentenceCase(menuTime),
                      style: const TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                        letterSpacing: 0.50,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
          InkWell(
            onTap: () async {
              Map<String, Map<String, Map>> menu = cartBox.get('menu');
              showOptionsOfMeal(menu[menuTime]!, menuTime, homeBloc, context);
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 76,
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xffcbffb3),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF6AA64F)),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Add',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6AA64F),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      letterSpacing: 0.50,
                    ),
                  ),
                ],
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
    BuildContext parentContext,
  ) {
    List<String> listOfMealTypes = menuOptions.keys.toList();
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xfffffcef),
            borderRadius: BorderRadius.circular(12),
          ),
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: listOfMealTypeOptions(
                    menuTime, listOfMealTypes, homeBloc, menuOptions),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> listOfMealTypeOptions(
      String mealTime,
      List<String> listOfMealTypes,
      HomeBloc homeBloc,
      Map<String, Map> menuOptions) {
    List<Widget> listOfMealOptions = [];
    for (var element in listOfMealTypes) {
      MenuDataModel menuData =
          MenuDataModel.fromJson(menuOptions[element]! as Map<String, dynamic>);
      listOfMealOptions.addAll([
        mealTypeChoserCard(homeBloc, element, mealTime, menuData),
        const SizedBox(height: 10),
        dashedDivider(context),
        const SizedBox(height: 24)
      ]);
    }
    return listOfMealOptions;
  }

  Widget mealTypeChoserCard(HomeBloc homeBloc, String mealType, String mealTime,
      MenuDataModel menuData) {
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
              mealTimeTag(mealType),
              const SizedBox(height: 12),
              mealCardBoldText("₹${menuData.price}/-"),
              const SizedBox(height: 12),
              SizedBox(
                width: (MediaQuery.sizeOf(context).width * 0.55) - 20,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        menuData.description, //TODO: change this to quantity
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
          menuImageForBottomSheet(
              menuData.mealTime, menuData.mealType, homeBloc)
        ],
      ),
    );
  }

  Widget menuImageForBottomSheet(
      String mealTime, String mealType, HomeBloc homeBloc) {
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
              bool cartTypeIsSubscription = cartBox.get("is_subscription",
                  defaultValue: subscriptionButtonIsExpanded);
              print(cartTypeIsSubscription);
              if (subscriptionButtonIsExpanded && cartTypeIsSubscription) {
                cartBox.put("is_subscription", true);
                homeBloc.add(HomePageAddToCartEvent(
                    isSubscription: true,
                    mealTime: mealTime,
                    mealType: mealType));
              } else if (orderNowButtonIsExpanded && !cartTypeIsSubscription) {
                cartBox.put("is_subscription", false);
                homeBloc.add(HomePageAddToCartEvent(
                    isSubscription: false,
                    mealTime: mealTime,
                    mealType: mealType));
              } else {
                Fluttertoast.showToast(
                  msg: "Clear the cart or checkout first",
                );
              }
              Navigator.pop(context);
              setState(() {});
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 28,
              width: 76,
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
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 16 / 11,
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
