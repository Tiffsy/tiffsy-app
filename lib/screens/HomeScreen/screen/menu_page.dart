import 'dart:ffi';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';

class MenuScreenHomePage extends StatefulWidget {
  const MenuScreenHomePage({
    super.key,
    required this.homeBloc,
  });
  final HomeBloc homeBloc;

  @override
  State<MenuScreenHomePage> createState() => _MenuScreenHomePageState();
}
class _MenuScreenHomePageState extends State<MenuScreenHomePage> {
  HomeFetchSuccessfulState menuState = HomeFetchSuccessfulState(menu: const []);
  Box cartBox = Hive.box("cart_box");
  bool orderNowButtonIsExpanded = false;
  bool subscriptionButtonIsExpanded = false;
  ScrollController topButtonsHorizontalScrollController = ScrollController();
  List<Container> carouselItems = [
    Container(
      child: SvgPicture.asset(
        'assets/images/vectors/Group 251img6.svg',
      ),
    ),
    Container(
      child: SvgPicture.asset(
        'assets/images/vectors/img2.svg',
        semanticsLabel: 'vector image',
      ),
    ),
    Container(
      child: SvgPicture.asset(
        'assets/images/vectors/img3.svg',
        semanticsLabel: 'vector image',
      ),
    ),
    Container(
      child: SvgPicture.asset(
        'assets/images/vectors/img4.svg',
        semanticsLabel: 'vector image',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is HomeFetchSuccessfulState) {
          menuState = state;
        } else if (state is HomeFetchSuccessfulIsCachedState) {
          return SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                upgradeToDeluxCard(() {}),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2, // Adjust line thickness as needed
                        color: Colors.black, // Customize line color
                        indent: 10,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16, top: 8, bottom: 8),
                      child: Text(
                        "Serving Today",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Charmonman",
                          height: 24 / 16,
                          letterSpacing: 0.15,
                          color: Color(0xff121212),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black,
                        endIndent: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        color: const Color(0xffFFBE1D),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listOfMenuCards(
                                menuState.menu, context, widget.homeBloc)),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 30,
                            width: MediaQuery.sizeOf(context).width,
                            color: const Color(0xffFFBE1D),
                          ),
                          Positioned(
                            top: 17,
                            child: Row(
                              children: [
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                circle(),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                // Column(
                //     children: listOfMenuCards(
                //         menuState.menu, context, widget.homeBloc)),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width - 39,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        orderNowExpandableButton(),
                        subscriptionExpandableButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '• You can order meals till below mentioned time for ordering today',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: 0.25,
                  ),
                ),
                cartSummaryList(
                  1,
                  0,
                  0,
                  context,
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              upgradeToDeluxCard(() {}),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2, // Adjust line thickness as needed
                      color: Colors.black, // Customize line color
                      indent: 10,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16, top: 8, bottom: 8),
                    child: Text(
                      "Serving Today",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Charmonman",
                        height: 24 / 16,
                        letterSpacing: 0.15,
                        color: Color(0xff121212),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.black,
                      endIndent: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      color: const Color(0xffFFBE1D),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: listOfMenuCards(
                              menuState.menu, context, widget.homeBloc)),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 30,
                          width: MediaQuery.sizeOf(context).width,
                          color: const Color(0xffFFBE1D),
                        ),
                        Positioned(
                          top: 17,
                          child: Row(
                            children: [
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.05,
                              ),
                              circle(),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              // Column(
              //     children: listOfMenuCards(
              //         menuState.menu, context, widget.homeBloc)),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width - 39,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      orderNowExpandableButton(),
                      subscriptionExpandableButton(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '• You can order meals till below mentioned time for ordering today',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0.25,
                ),
              ),
              cartSummaryList(
                1,
                0,
                0,
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget cartSummaryList(
      int breakfast, int lunch, int dinner, BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            cartSummaryEntry("Dinner", "Before 6:30 PM ", breakfast),
          ],
        ),
      ),
    );
  }

  Widget cartSummaryEntry(String mealType, String time, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 56,
          child: Center(
            child: Text(
              mealType[0],
              style: const TextStyle(
                color: Color(0xFF121212),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                letterSpacing: 0.15,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          mealType,
          style: const TextStyle(
            color: Color(0xFF121212),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            letterSpacing: 0.50,
          ),
        ),
        const Spacer(),
        Text(
          time,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Color(0xFF121212),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 16 / 11,
            letterSpacing: 0.50,
          ),
        ),
        const SizedBox(width: 15),
        // Container(
        //   width: 18,
        //   height: 18,
        //   decoration: ShapeDecoration(
        //     color: const Color(0xFF6AA64F),
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        //   ),
        //   child: Center(
        //     child: Text(
        //       quantity.toString(),
        //       textAlign: TextAlign.right,
        //       style: const TextStyle(
        //         color: Color(0xFFffffff),
        //         fontSize: 11,
        //         fontFamily: 'Roboto',
        //         fontWeight: FontWeight.w700,
        //         height: 16 / 11,
        //         letterSpacing: 0.50,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget customMenuTab(BuildContext context, MenuDataModel menuPage) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xfffffcef),
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2, // Adjust line thickness as needed
                          color: Colors.black, // Customize line color
                          indent: 10,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 8),
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Charmonman",
                            height: 24 / 16,
                            letterSpacing: 0.15,
                            color: Color(0xff121212),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.black,
                          endIndent: 15,
                        ),
                      ),
                    ],
                  ),
                  content: Text(menuPage.description),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
        },
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 70,
          height: 75,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.grey.withOpacity(0.5), // Adjust color and opacity
                  blurRadius: 5.0, // Adjust blur radius
                  spreadRadius: 2.0, // Adjust spread radius (optional)
                  offset: const Offset(2.0, 2.0), // Adjust offset (optional)
                ),
              ],
              borderRadius: BorderRadius.circular(16.0), // Set desired radius
              color: Colors.white,
              // Add border if needed
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: mealTimeTagCustom(menuPage.mealTime),
                ),
                Container(
                    width: MediaQuery.sizeOf(context).width - 250,
                    child: mealCardBoldText(menuPage.title))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget circle() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
        height: orderNowButtonIsExpanded ? 170 : 46,
        width: subscriptionButtonIsExpanded
            ? 0
            : (orderNowButtonIsExpanded
                ? (MediaQuery.sizeOf(context).width - 40)
                : ((MediaQuery.sizeOf(context).width - 40) / 2) - 6),
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(orderNowButtonIsExpanded ? 20 : 12),
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
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 46,
                  width: (MediaQuery.sizeOf(context).width - 40) / 2 - 6,
                  child: const Center(
                    child: Text(
                      "Order Now!",
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),
                rowOfOrderNowCards(context, widget.homeBloc),
              ],
            ),
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
        height: subscriptionButtonIsExpanded ? 170 : 46,
        width: orderNowButtonIsExpanded
            ? 0
            : orderNowButtonIsExpanded
                ? 0
                : (subscriptionButtonIsExpanded
                    ? (MediaQuery.sizeOf(context).width - 40)
                    : ((MediaQuery.sizeOf(context).width - 40) / 2) - 6),
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(subscriptionButtonIsExpanded ? 20 : 12),
            side: BorderSide(
                width: subscriptionButtonIsExpanded ? 1.5 : 1,
                color: const Color(0xffFFBE1D)),
          ),
          color: subscriptionButtonIsExpanded
              ? const Color(0xfffffcef)
              : const Color(0xffffbe1d),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 46,
                  width: (MediaQuery.sizeOf(context).width - 40) / 2 - 6,
                  child: const Center(
                    child: Text(
                      "Get Subscription!",
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),
                rowOfSubscriptionCards(context, widget.homeBloc),
              ],
            ),
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
          customMenuTab(context, temp[key]![0]),
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

  bool timeCheck(TimeOfDay currentTime, TimeOfDay desiredTime) {
    if (currentTime.hour < desiredTime.hour ||
        (currentTime.hour == desiredTime.hour &&
            currentTime.minute < desiredTime.minute)) {
      return false;
    } else {
      // Current time is after or equal to the desired time
      return true;
    }
  }

  Widget rowOfOrderNowCards(BuildContext context, HomeBloc homeBloc) {
    TimeOfDay breakfastTime = TimeOfDay(hour: 7, minute: 30);
    TimeOfDay lunchTime = TimeOfDay(hour: 11, minute: 30);
    TimeOfDay dinnerTime = TimeOfDay(hour: 18, minute: 30);
    TimeOfDay currentTime = TimeOfDay.now();

    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          orderNowButtons(
              context,
              "assets/images/vectors/home_screen/Brunch.svg",
              "breakfast",
              homeBloc,
              true),
          orderNowButtons(
              context,
              "assets/images/vectors/home_screen/Ramen.svg",
              "lunch",
              homeBloc,
              true),
          orderNowButtons(
              context,
              "assets/images/vectors/home_screen/Spaghetti.svg",
              "dinner",
              homeBloc,
              timeCheck(currentTime, dinnerTime)),
        ],
      ),
    );
  }

  Widget rowOfSubscriptionCards(BuildContext context, HomeBloc homeBloc) {
    Map<String, bool> enabledButtons = {
      "breakfast": true,
      "lunch": true,
      "dinner": true,
    };
    if (cartBox.get("is_subscription", defaultValue: true)) {
      List cart = cartBox.get("cart", defaultValue: []);
      cart.forEach((element) {
        enabledButtons[element[0]["mealTime"]] = false;
      });
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          orderSubscriptionButtons(
              context,
              "assets/images/vectors/home_screen/Brunch.svg",
              enabledButtons["breakfast"] ?? true,
              "breakfast",
              homeBloc,
              false),
          orderSubscriptionButtons(
              context,
              "assets/images/vectors/home_screen/Ramen.svg",
              enabledButtons["lunch"] ?? true,
              "lunch",
              homeBloc,
              false),
          orderSubscriptionButtons(
              context,
              "assets/images/vectors/home_screen/Spaghetti.svg",
              enabledButtons["dinner"] ?? true,
              "dinner",
              homeBloc,
              true),
        ],
      ),
    );
  }

  Widget orderNowButtons(BuildContext context, String imageAsset,
      String menuTime, HomeBloc homeBloc, bool active) {
    return !active
        ? SizedBox(
            child: InkWell(
              onTap: () async {
                Map<String, Map<String, Map>> menu = cartBox.get('menu');
                showOptionsOfMeal(menu[menuTime]!, menuTime, homeBloc, context);
              },
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
                        width: 86,
                        child: Column(
                          children: [
                            const SizedBox(height: 7),
                            SizedBox(
                                height: 41,
                                child: SvgPicture.asset(imageAsset)),
                            Text(
                              toSentenceCase(menuTime),
                              style: const TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 12,
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
                  Container(
                    width: 86,
                    height: 30,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xffcbffb3),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF6AA64F)),
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
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AbsorbPointer(
                  absorbing: active,
                  child: InkWell(
                    onTap: () async {
                      Map<String, Map<String, Map>> menu = cartBox.get('menu');
                      showOptionsOfMeal(
                          menu[menuTime]!, menuTime, homeBloc, context);
                    },
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
                              width: 86,
                              child: Column(
                                children: [
                                  const SizedBox(height: 7),
                                  SizedBox(
                                      height: 41,
                                      child: SvgPicture.asset(imageAsset)),
                                  Text(
                                    toSentenceCase(menuTime),
                                    style: const TextStyle(
                                      color: Color(0xFF121212),
                                      fontSize: 12,
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
                        Container(
                          width: 86,
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xffFFDDDD),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: const Color(0xffF84545)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Coming Soon',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xffF84545),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  height: 16 / 12,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget orderSubscriptionButtons(BuildContext context, String imageAsset,
      bool isEnabled, String menuTime, HomeBloc homeBloc, bool active) {
    return active
        ? SizedBox(
            child: InkWell(
              onTap: () async {
                Map<String, Map<String, Map>> menu = cartBox.get('menu');
                showOptionsOfMeal(menu[menuTime]!, menuTime, homeBloc, context);
              },
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
                        width: 86,
                        child: Column(
                          children: [
                            const SizedBox(height: 7),
                            SizedBox(
                                height: 41,
                                child: SvgPicture.asset(imageAsset)),
                            Text(
                              toSentenceCase(menuTime),
                              style: const TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 12,
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
                  Container(
                    width: 86,
                    height: 30,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xffcbffb3),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF6AA64F),
                        ),
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
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox(
            child: AbsorbPointer(
              absorbing: true,
              child: InkWell(
                onTap: () async {
                  Map<String, Map<String, Map>> menu = cartBox.get('menu');
                  showOptionsOfMeal(menu[menuTime]!, menuTime, homeBloc, context);
                },
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
                          width: 86,
                          child: Column(
                            children: [
                              const SizedBox(height: 7),
                              SizedBox(
                                  height: 41,
                                  child: SvgPicture.asset(imageAsset)),
                              Text(
                                toSentenceCase(menuTime),
                                style: const TextStyle(
                                  color: Color(0xFF121212),
                                  fontSize: 12,
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
                    Container(
                      width: 86,
                      height: 30,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xffFFDDDD),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: const Color(0xffF84545),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Coming Soon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xffF84545),
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
          MenuImageForBottomSheet(
            mealTime: menuData.mealTime,
            mealType: menuData.mealType,
            homeBloc: homeBloc,
            subscriptionButtonIsExpanded: subscriptionButtonIsExpanded,
          )
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
            child: Column(
              children: [
                CarouselSlider(
                    items: carouselItems,
                    options: CarouselOptions(
                      height:
                          (MediaQuery.sizeOf(context).width - 40) * (154 / 372),
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 500),
                      viewportFraction: 0.8,
                    ))
              ],
            )),
      );
    });
  }
}

class MenuImageForBottomSheet extends StatefulWidget {
  const MenuImageForBottomSheet({
    super.key,
    required this.subscriptionButtonIsExpanded,
    required this.homeBloc,
    required this.mealTime,
    required this.mealType,
  });
  final HomeBloc homeBloc;
  final bool subscriptionButtonIsExpanded;
  final String mealTime;
  final String mealType;

  @override
  State<MenuImageForBottomSheet> createState() =>
      _MenuImageForBottomSheetState();
}

class _MenuImageForBottomSheetState extends State<MenuImageForBottomSheet> {
  Box cartBox = Hive.box("cart_box");
  bool? cartBoxIsSubscription;
  int quantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartBoxIsSubscription = cartBox.get("is_subscription");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    if (widget.subscriptionButtonIsExpanded && cartBoxIsSubscription != false) {
      List cart = cartBox.get("cart", defaultValue: []);
      for (int i = 0; i < cart.length; i++) {
        if (cart[i][0]["mealTime"] == widget.mealTime) {
          quantity = cart[i][1];
        }
      }
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
                if (quantity == 0) {
                  bool cartTypeIsSubscription = cartBox.get("is_subscription",
                      defaultValue: widget.subscriptionButtonIsExpanded);
                  if (cartTypeIsSubscription) {
                    cartBox.put("is_subscription", true);
                    widget.homeBloc.add(HomePageAddToCartEvent(
                        isSubscription: true,
                        mealTime: widget.mealTime,
                        mealType: widget.mealType));
                  } else {
                    Fluttertoast.showToast(
                      msg: "Clear the cart or checkout first",
                    );
                  }
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg:
                          "${toSentenceCase(widget.mealType)} ${toSentenceCase(widget.mealTime)} added to cart!",
                      toastLength: Toast.LENGTH_SHORT);
                  setState(() {});
                } else {
                  Fluttertoast.showToast(msg: "Can add only one of each item");
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 96,
                height: 32,
                decoration: BoxDecoration(
                  color: (quantity == 0)
                      ? Color(0xffcbffb3)
                      : Colors.grey.shade300,
                  border: Border.all(
                      width: 1,
                      color: (quantity == 0)
                          ? Color(0xff6aa64f)
                          : Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    (quantity == 0) ? "Add" : "Added",
                    style: TextStyle(
                      color: (quantity == 0)
                          ? Color(0xff6aa64f)
                          : Colors.grey.shade700,
                      fontSize: 12,
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
    } else if (!widget.subscriptionButtonIsExpanded &&
        cartBoxIsSubscription != true) {
      List cart = cartBox.get("cart", defaultValue: []);
      for (int i = 0; i < cart.length; i++) {
        if (cart[i][0]["mealTime"] == widget.mealTime &&
            cart[i][0]["mealType"] == widget.mealType) {
          quantity = cart[i][1];
        }
      }
      return (quantity == 0)
          ? SizedBox(
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
                      bool cartTypeIsSubscription = cartBox.get(
                          "is_subscription",
                          defaultValue: widget.subscriptionButtonIsExpanded);
                      if (!cartTypeIsSubscription) {
                        cartBox.put("is_subscription", false);
                        widget.homeBloc.add(HomePageAddToCartEvent(
                            isSubscription: false,
                            mealTime: widget.mealTime,
                            mealType: widget.mealType));
                      } else {
                        Fluttertoast.showToast(
                          msg: "Clear the cart or checkout first",
                        );
                      }
                      Fluttertoast.showToast(
                          msg:
                              "${toSentenceCase(widget.mealType)} ${toSentenceCase(widget.mealTime)} added to cart!",
                          toastLength: Toast.LENGTH_SHORT);
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 96,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xffcbffb3),
                        border: Border.all(
                            width: 1, color: const Color(0xff6aa64f)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Color(0xFF6AA64F),
                            fontSize: 12,
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
            )
          : SizedBox(
              width: width * 0.35,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    'assets/images/vectors/thali_full.png',
                    fit: BoxFit.contain,
                    width: width * 0.3,
                  ),
                  Container(
                    width: 96,
                    height: 32,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFCBFFB2),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF329C00)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            widget.homeBloc.add(
                              HomePageRemoveFromCartEvent(
                                mealTime: widget.mealTime,
                                mealType: widget.mealType,
                              ),
                            );
                            setState(() {
                              quantity -= 1;
                            });
                          },
                          child: const Icon(
                            Icons.remove_rounded,
                            size: 20,
                            color: Color(0xFF329C00),
                          ),
                        ),
                        Text(
                          quantity.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF329C00),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 20 / 16,
                            letterSpacing: 0.15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            widget.homeBloc.add(HomePageAddToCartEvent(
                                isSubscription: false,
                                mealTime: widget.mealTime,
                                mealType: widget.mealType));

                            setState(() {
                              quantity += 1;
                            });
                          },
                          child: const Icon(
                            Icons.add_rounded,
                            size: 20,
                            color: Color(0xFF329C00),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
    } else {
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
                Fluttertoast.showToast(msg: "Clear the cart or checkout first");
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 96,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xffdfdfdf),
                  border: Border.all(width: 1, color: const Color(0xff666666)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
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
}

Text mealCardBoldText(String text) {
  // Returns the string as a Text widget with the bold formatting mentioned in the
  // design.
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    softWrap: true,
    overflow: TextOverflow.clip,
  );
}

Widget mealTimeTagCustom(
  String mealTime,
) {
  // Returns the meal time string placed in the tag like container as mentioned in the
  // design.
  return Stack(
    alignment: AlignmentDirectional.center,
    children: [
      Positioned(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffffbe1d)),
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xffffbe1d),
          ),
          width: 150,
          height: 23,
          child: Center(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  toSentenceCase(mealTime),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 16 / 11,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        widthFactor: 2.5,
        child: Image.asset(
          'assets/images/vectors/thali_full.png',
          fit: BoxFit.cover,
          width: 60,
          height: 60,
        ),
      ),
    ],
  );
}

Widget mealTimeTag(String mealTime) {
  // Returns the meal time string placed in the tag like container as mentioned in the
  // design.
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffffbe1d)),
      borderRadius: BorderRadius.circular(6),
      color: const Color(0xfffffcef),
    ),
    width: 76,
    height: 23,
    child: Center(
      child: Text(
        toSentenceCase(mealTime),
        style: const TextStyle(
          color: Color(0xffffbe1d),
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
