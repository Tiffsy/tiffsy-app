import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:tiffsy_app/Helpers/loading_animation.dart";
import "package:tiffsy_app/Helpers/page_router.dart";
import "package:tiffsy_app/screens/AddAddressScreen/screen/add_address_screen.dart";
import "package:tiffsy_app/screens/CartScreen/screen/cart_screen.dart";
import "package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart";
import "package:tiffsy_app/screens/HomeScreen/model/home_model.dart";
import "package:tiffsy_app/screens/SubscriptionScreen/screen/subscription_screen.dart";

class CartScreenHomePage extends StatefulWidget {
  const CartScreenHomePage({super.key, required this.homeBloc});
  final HomeBloc homeBloc;

  @override
  State<CartScreenHomePage> createState() => _CartScreenHomePageState();
}

class _CartScreenHomePageState extends State<CartScreenHomePage> {
  Box cartBox = Hive.box("cart_box");
  List<Widget> listOfCards = [];
  void onListEmpty() {
    setState(() {
      listOfCards = [];
      print(listOfCards);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOfCards = listOfCartCards(HomeBloc());
  }

  @override
  Widget build(BuildContext context) {
    return listOfCards.isEmpty
        ? LoadingAnimation.emptyDataAnimation(context, "Cart Is Empty")
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  "Choose delivery address on top",
                ),
                const SizedBox(height: 10),
                listOfCards.isEmpty
                    ? const SizedBox()
                    : orderNowButton(() {
                        if (Hive.box("address_box")
                            .get("default_address", defaultValue: {}).isEmpty) {
                          Navigator.push(context,
                              SlideTransitionRouter.toNextPage(AddAddressScreen(
                            onAdd: () {
                              setState(() {});
                            },
                          )));
                        } else if (cartBox.get("is_subscription")) {
                          Navigator.push(
                              context,
                              SlideTransitionRouter.toNextPage(
                                  const CartScreen()));
                        } else {
                          cartBox.put("subType", 1);
                          Navigator.push(
                              context,
                              SlideTransitionRouter.toNextPage(
                                  const SubscriptionScreen(noOfDays: 1)));
                        }
                      }),
                const SizedBox(height: 10),
              ],
            ),
          );
  }

  List<Widget> listOfCartCards(HomeBloc homeBloc) {
    List<Widget> listOfMenuCards = [];
    List cartItems = cartBox.get("cart", defaultValue: []);

    for (var element in cartItems) {
      listOfMenuCards.add(
        CustomeCartCard(
          cartItem: element,
          homeBloc: homeBloc,
          onListEmpty: onListEmpty,
        ),
      );
    }
    return listOfMenuCards;
  }
}

class CustomeCartCard extends StatefulWidget {
  const CustomeCartCard(
      {super.key,
      required this.cartItem,
      required this.homeBloc,
      required this.onListEmpty});
  final List cartItem;
  final HomeBloc homeBloc;
  final Function onListEmpty;

  @override
  State<CustomeCartCard> createState() => _CustomeCartCardState();
}

class _CustomeCartCardState extends State<CustomeCartCard> {
  Box cartBox = Hive.box("cart_box");
  bool isDeleted = false;

  late int quantity;

  void onQuanitiyChange(int newQuantity) async {
    setState(() {
      quantity = newQuantity;
    });
    if (quantity < 1) {
      setState(() {
        isDeleted = true;
      });
      await Future.delayed(const Duration(milliseconds: 250));
    }
    if (cartBox.get("cart", defaultValue: []).isEmpty) {
      widget.onListEmpty();
      cartBox.delete("is_subscription");
    }
  }

  late bool cartType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity = widget.cartItem[1];
    cartType = cartBox.get("is_subscription", defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    Map menu = cartBox.get('menu');

    Map menuObject =
        menu[widget.cartItem[0]["mealTime"]][widget.cartItem[0]["mealType"]];
    Map<String, dynamic> menuObjectCasted = {};
    menuObject.forEach((key, value) {
      menuObjectCasted[key.toString()] = value;
    });
    MenuDataModel menuData = MenuDataModel.fromJson(menuObjectCasted);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      height: isDeleted ? 0 : 170,
      width: MediaQuery.sizeOf(context).width - 20,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
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
                      child: Row(
                        children: [
                          Flexible(
                            child: mealCardBoldText(menuData.title),
                          ),
                        ],
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
                cartType
                    ? cartImageForSubscriptionEntries(
                        widget.homeBloc, menuData, context)
                    : cartImageForOrderNowEntries(
                        widget.homeBloc, menuData, quantity, context)
              ],
            ),
            const SizedBox(height: 16),
            dashedDivider(context),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Widget cartImageForSubscriptionEntries(
    HomeBloc homeBloc,
    MenuDataModel menuPage,
    BuildContext context,
  ) {
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
              homeBloc.add(
                HomePageRemoveFromCartEvent(
                  mealTime: menuPage.mealTime,
                  mealType: menuPage.mealType,
                ),
              );

              await Future.delayed(const Duration(milliseconds: 255));
              onQuanitiyChange(0);
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 32,
              width: 96,
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
                    height: 20 / 16,
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

  Widget cartImageForOrderNowEntries(
    HomeBloc homeBloc,
    MenuDataModel menuPage,
    int quantity,
    BuildContext context,
  ) {
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
          Container(
            width: 96,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFCBFFB2),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF329C00)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    homeBloc.add(
                      HomePageRemoveFromCartEvent(
                        mealTime: menuPage.mealTime,
                        mealType: menuPage.mealType,
                      ),
                    );

                    onQuanitiyChange(quantity - 1);
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
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 20 / 16,
                    letterSpacing: 0.15,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    homeBloc.add(HomePageAddToCartEvent(
                        isSubscription: false,
                        mealTime: menuPage.mealTime,
                        mealType: menuPage.mealType));
                    onQuanitiyChange(quantity + 1);
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
  }
}
// These functions are for decorative purpose only, no state management happens here

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
