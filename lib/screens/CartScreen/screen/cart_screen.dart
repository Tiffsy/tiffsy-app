import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/screens/CartScreen/bloc/cart_bloc.dart';
import 'package:tiffsy_app/screens/SubscriptionScreen/screen/subscription_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, bool> selectedList = {
    "Order Now": false,
    "Weekly Subscription": false,
    "15-Day Subscription": false,
    "Monthly Subscription": false
  };

  int noOfDaysForSubscription = 0;

  double price = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List cart = Hive.box("cart_box").get("cart");
    for (var element in cart) {
      price = price + element["price"];
    }
  }

  CartBloc cartBloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    double widthAdjustedForPadding = MediaQuery.sizeOf(context).width - 80;
    return BlocProvider(
      create: (context) => cartBloc,
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xffFFFDF8),
            appBar: AppBar(
              backgroundColor: const Color(0xffFFFDF8),
              leadingWidth: 64,
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xff323232),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(
                "Choose Order type",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff121212),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        subscriptionContainersArranged(widthAdjustedForPadding),
                  ),
                  const SizedBox(height: 24),
                  AnimatedOpacity(
                    opacity: (noOfDaysForSubscription == 0) ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        cartPriceMessageBox(
                            "Your Total: ₹${(price * noOfDaysForSubscription).toStringAsFixed(2)}"),
                        const SizedBox(height: 12),
                        proceedButton(
                          () {
                            Hive.box("cart_box").put("subType", noOfDaysForSubscription);
                            cartBloc.add(
                              CartScreenOnProcedButtonPressEvent(cost: price),
                            );
                            Navigator.push(
                              context,
                              SlideTransitionRouter.toNextPage(
                                SubscriptionScreen(
                                    noOfDays: noOfDaysForSubscription),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget subscriptionContainersArranged(double widthAdjustedForPadding) {
    return SizedBox(
      width: widthAdjustedForPadding,
      child: Column(
        children: [
          Row(
            children: [
              subscriptionContainer(
                "Order Now",
                "assets/images/vectors/cart_screen/order_now_subs.svg",
                1,
                widthAdjustedForPadding / 2,
              ),
              subscriptionContainer(
                "Weekly Subscription",
                "assets/images/vectors/cart_screen/weekly_subs.svg",
                7,
                widthAdjustedForPadding / 2,
              )
            ],
          ),
          Row(
            children: [
              subscriptionContainer(
                "15-Day Subscription",
                "assets/images/vectors/cart_screen/fifteen_day_subs.svg",
                15,
                widthAdjustedForPadding / 2,
              ),
              subscriptionContainer(
                "Monthly Subscription",
                "assets/images/vectors/cart_screen/monthly_subs.svg",
                30,
                widthAdjustedForPadding / 2,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget subscriptionContainer(
    String text,
    String asset,
    int noOfDays,
    double width,
  ) {
    return GestureDetector(
      onTap: () {
        selectedList.forEach((key, value) {
          if (key == text) {
            selectedList[key] = true;
          } else {
            selectedList[key] = false;
          }
        });
        noOfDaysForSubscription = noOfDays;
        setState(() {});
      },
      child: SizedBox(
        height: 200,
        width: width,
        child: Center(
          child: AnimatedContainer(
            height: 200 - (selectedList[text]! ? 10 : 15),
            width: width - (selectedList[text]! ? 10 : 15),
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            decoration: ShapeDecoration(
              color: selectedList[text]!
                  ? const Color(0xffFFBE1D)
                  : const Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x1EFFBE1D),
                  blurRadius: 12,
                  offset: (selectedList[text]!
                      ? const Offset(0, 9)
                      : const Offset(0, 4)),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(asset),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Color(0xFF121212),
                            fontSize: 11,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 16 / 11,
                            letterSpacing: 0.50,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget cartPriceMessageBox(String message) {
  return Container(
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
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 20 / 16,
          letterSpacing: 0.10,
        ),
      ),
    ),
  );
}

Widget proceedButton(VoidCallback onpress) {
  Widget buttonText = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      Text(
        "Proceed",
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
    borderRadius: BorderRadius.circular(8),
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
