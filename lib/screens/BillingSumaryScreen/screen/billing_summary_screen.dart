import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:hive/hive.dart";
import "package:lottie/lottie.dart";
import "package:tiffsy_app/Helpers/loading_animation.dart";
import "package:tiffsy_app/Helpers/page_router.dart";
import "package:tiffsy_app/screens/BillingSumaryScreen/bloc/billing_summary_bloc.dart";
import "package:tiffsy_app/screens/BillingSumaryScreen/model/coupon_data_model.dart";
import "package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart";

class BillingSummaryScreen extends StatefulWidget {
  final List<CouponDataModel> couponList;
  const BillingSummaryScreen({Key? key, required this.couponList})
      : super(key: key);

  @override
  State<BillingSummaryScreen> createState() => _BillingSummaryScreenState();
}

class _BillingSummaryScreenState extends State<BillingSummaryScreen> {
  TextEditingController couponCodeController = TextEditingController();
  late Map<String, double> summaryBreakdown;
  late double grandTotal;
  Map<String, List<int>> discountList = {};
  List<DropdownMenuEntry> coupons = [];
  int discount = 0;
  double bill = 0;

  Map<String, double> getSummaryBreakdown() {
    return {"Subtotal": 0, "Discount (-)": 0, "Shipping": 0};
  }

  double calculateTotal(Map<String, double> summaryBreakdown) {
    double grandTotal = 0;
    summaryBreakdown.forEach((key, value) {
      grandTotal += value;
    });
    return grandTotal;
  }

  void applyCoupon() {
    String selectedCouponCode = couponCodeController.text;
    if (discountList.containsKey(selectedCouponCode)) {
      int discountPrnct = discountList[selectedCouponCode]![0];
      int maxPrice = discountList[selectedCouponCode]![1];
      int minPrice = discountList[selectedCouponCode]![2];

      if (bill < minPrice) {
        setState(() {
          summaryBreakdown["Discount (-)"] = 0.0;
          grandTotal = calculateTotal(summaryBreakdown);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Add items worth ₹${minPrice-bill} more to apply'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        double discountAmt = (bill * discountPrnct / 100) > maxPrice* 1.0 ? maxPrice * 1.0 : (bill * discountPrnct / 100);
        setState(() {
          summaryBreakdown["Discount (-)"] = ((discountAmt) * (-1));
          grandTotal = calculateTotal(summaryBreakdown);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xffCBFFB3),
            content: Text('Voila! You Saved ₹$discountAmt', style: TextStyle(
              color: Colors.black
            ),),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (selectedCouponCode.isEmpty) {
        setState(() {
          discount = 0;
          summaryBreakdown["Discount (-)"] = ((bill * discount / 100) * (-1));
          grandTotal = calculateTotal(summaryBreakdown);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid coupon code'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.couponList.length; i++) {
      DropdownMenuEntry x = DropdownMenuEntry(
          value: widget.couponList[i].discountPrnct,
          label: widget.couponList[i].cpnCode);
      coupons.add(x);
      discountList[widget.couponList[i].cpnCode] = [];
      discountList[widget.couponList[i].cpnCode]!
          .add(widget.couponList[i].discountPrnct);
      discountList[widget.couponList[i].cpnCode]!
          .add(widget.couponList[i].maxDiscount);
      discountList[widget.couponList[i].cpnCode]!
          .add(widget.couponList[i].minPrice);
    }
    summaryBreakdown = getSummaryBreakdown();
    Box cart_box = Hive.box("cart_box");
    List cart = cart_box.get("cart");
    if (cart_box.get("is_subscription")) {
      for (var element in cart) {
        bill += int.parse(element[0]["price"].toString());
      }
      int subType = cart_box.get("subType");
      bill = bill * subType;
    } else {
      for (var element in cart) {
        bill += int.parse(element[0]["price"].toString()) *
            int.parse(element[1].toString());
      }
    }

    summaryBreakdown["Subtotal"] = bill * 1.0;
    summaryBreakdown["Discount"] = ((bill * discount / 100) * (-1));
    grandTotal = calculateTotal(summaryBreakdown);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BillingSummaryBloc(
        onPaymentSuccess: () {
          Hive.box("cart_box").put("cart", []);
          Hive.box("cart_box").delete("is_subscription");
          Hive.box("coupon").clear();
        },
      ),
      child: BlocConsumer<BillingSummaryBloc, BillingSummaryState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is RazorpayFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is RazorpayInProgress) {
            return Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                leadingWidth: 64,
                titleSpacing: 0,
                backgroundColor: const Color(0xffffffff),
                surfaceTintColor: const Color(0xffffffff),
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
                  "Billing summary",
                  style: TextStyle(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff121212),
                  ),
                ),
              ),
              body: Center(
                child: LoadingAnimation.circularLoadingAnimation(context),
              ),
            );
          } else if (state is TransactionLoadingState) {
            return Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                leadingWidth: 64,
                titleSpacing: 0,
                backgroundColor: const Color(0xffffffff),
                surfaceTintColor: const Color(0xffffffff),
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
                  "Billing summary",
                  style: TextStyle(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff121212),
                  ),
                ),
              ),
              body: Center(
                child: LoadingAnimation.circularLoadingAnimation(context),
              ),
            );
          } else if (state is RazorpaySuccess) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: const Color(0xffffffff),
                  appBar: AppBar(
                    leadingWidth: 64,
                    titleSpacing: 0,
                    backgroundColor: const Color(0xffffffff),
                    surfaceTintColor: const Color(0xffffffff),
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
                      "Billing summary",
                      style: TextStyle(
                        fontSize: 20,
                        height: 28 / 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff121212),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: SingleChildScrollView(
                      child: Column(
                          children:
                              billingInformation(summaryBreakdown, grandTotal) +
                                  couponEntryBox(couponCodeController, coupons,
                                      applyCoupon, "Coupons") +
                                  proceedButton(() {
                                    Hive.box("coupon").put("cpn",couponCodeController.text);
                                    BlocProvider.of<BillingSummaryBloc>(context)
                                        .initializePayment(grandTotal);
                                  })),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(color: Color(0x88000000)),
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                PaymentSuccessfulPopUp()
              ],
            );
          } else {
            return Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                leadingWidth: 64,
                titleSpacing: 0,
                backgroundColor: const Color(0xffffffff),
                surfaceTintColor: const Color(0xffffffff),
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
                  "Billing summary",
                  style: TextStyle(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff121212),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                      children:
                          billingInformation(summaryBreakdown, grandTotal) +
                              couponEntryBox(couponCodeController, coupons,
                                  applyCoupon, "Coupons") +
                              proceedButton(() {
                                Hive.box("coupon").put("cpn",couponCodeController.text,);
                                BlocProvider.of<BillingSummaryBloc>(context)
                                    .initializePayment(grandTotal);
                                // Navigator.push(
                                //     context,
                                //     SlideTransitionRouter.toNextPage(
                                //         PaymentCheckoutScreen(amount: grandTotal)));
                              })),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

List<Widget> billingInformation(
    Map<String, double> billBreakdown, double total) {
  List<Widget> listOfBillBreakdown = [];
  billBreakdown.forEach((key, value) {
    listOfBillBreakdown.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          amountSubPartText(key, false),
          const Spacer(),
          amountSubPartText(value.abs().toStringAsFixed(2), true),
        ],
      ),
    );
    listOfBillBreakdown.add(const SizedBox(height: 12));
  });
  listOfBillBreakdown.addAll({
    const Divider(
      color: Color(0x33121212),
      thickness: 0,
      height: 0,
    ),
    const SizedBox(height: 20),
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        amountTotalText("Grand Total"),
        const Spacer(),
        amountTotalText(total.toStringAsFixed(2)),
      ],
    ),
  });
  return listOfBillBreakdown;
}

Widget dropDownMenu(
    String label,
    List<DropdownMenuEntry<dynamic>> dropDownMenuEntries,
    TextEditingController controller) {
  return DropdownMenu(
    trailingIcon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 24,
    ),
    enableSearch: true,
    enableFilter: true,
    dropdownMenuEntries: dropDownMenuEntries,
    controller: controller,
    requestFocusOnTap: true,
    label: Text(label),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0x66121212),
        height: 24 / 16,
      ),
    ),
    expandedInsets: EdgeInsets.zero,
  );
}

Widget amountSubPartText(String text, bool bold) {
  return Text(
    text,
    style: TextStyle(
      color: bold ? const Color(0xff121212) : const Color(0x99121212),
      fontSize: 14,
      fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
      height: 20 / 14,
      letterSpacing: 0.25,
    ),
  );
}

Widget amountTotalText(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Color(0xff121212),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 24 / 16,
      letterSpacing: 0.15,
    ),
  );
}

// convert this to a statefulwidget!

// List<Widget> couponEntryBox(TextEditingController couponTextEditingController,
//     List<String> listOfcoupons, Function clearAll) {
//   return [
//     const SizedBox(height: 28),
//     TextFormField(
//       controller: couponTextEditingController,
//       validator: (value) {
//         return (listOfcoupons.contains(value) ? "Applied Successfully" : null);
//       },
//       maxLines: 1,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         letterSpacing: 0.5,
//         height: 24 / 16,
//       ),
//       decoration: InputDecoration(
//         constraints: const BoxConstraints(maxHeight: 56),
//         suffixIcon: couponTextEditingController.text.isEmpty
//             ? Container()
//             : IconButton(
//                 color: const Color(0xff121212),
//                 onPressed: () {
//                   clearAll();
//                 },
//                 icon: const Icon(
//                   Icons.cancel_outlined,
//                   size: 24,
//                 ),
//               ),
//         labelText: "COUPON",
//         labelStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//           color: Color(0x66121212),
//           height: 24 / 16,
//         ),
//       ),
//     ),
//     const SizedBox(height: 16)
//   ];
// }

List<Widget> couponEntryBox(
  TextEditingController couponTextEditingController,
  List<DropdownMenuEntry> dropDownMenuEntries,
  Function onApply,
  String label,
) {
  return [
    const SizedBox(height: 28),
    Row(
      children: [
        Expanded(
          child: DropdownMenu(
            trailingIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24,
            ),
            enableSearch: true,
            enableFilter: true,
            dropdownMenuEntries: dropDownMenuEntries,
            controller: couponTextEditingController,
            requestFocusOnTap: true,
            label: Text(label),
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0x66121212),
                height: 24 / 16,
              ),
            ),
            expandedInsets: EdgeInsets.zero,
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            onApply();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xffCBFFB3), // Set the button color to green
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                    color: const Color(0xff329C00)) // Set the border radius
                ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Apply",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set the text color to white
              ),
            ),
          ),
        )
      ],
    ),
    // TextFormField(
    //   controller: couponTextEditingController,
    //   validator: (value) {
    //     return (listOfcoupons.contains(value) ? "Applied Successfully" : null);
    //   },
    //   maxLines: 1,
    //   style: const TextStyle(
    //     fontSize: 16,
    //     fontWeight: FontWeight.w400,
    //     letterSpacing: 0.5,
    //     height: 24 / 16,
    //   ),
    //   decoration: InputDecoration(
    //     constraints: const BoxConstraints(maxHeight: 56),
    //     suffixIcon: couponTextEditingController.text.isEmpty
    //         ? Container()
    //         : IconButton(
    //             color: const Color(0xff121212),
    //             onPressed: () {
    //               clearAll();
    //             },
    //             icon: const Icon(
    //               Icons.cancel_outlined,
    //               size: 24,
    //             ),
    //           ),
    //     labelText: "COUPON",
    //     hintText: "COUPON",
    //     labelStyle: const TextStyle(
    //       fontSize: 16,
    //       fontWeight: FontWeight.w400,
    //       color: Color(0x66121212),
    //       height: 24 / 16,
    //     ),
    //   ),
    // ),
    const SizedBox(height: 16)
  ];
}

List<Widget> proceedButton(Function onPress) {
  return [
    InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        onPress();
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 40),
        decoration: BoxDecoration(
          color: const Color(0xffffbe1d),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Proceed",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xff121212),
                  height: 20 / 16,
                ),
              ),
            ],
          ),
        ),
      ),
    )
  ];
}

class PaymentSuccessfulPopUp extends StatefulWidget {
  const PaymentSuccessfulPopUp({super.key});

  @override
  State<PaymentSuccessfulPopUp> createState() => _PaymentSuccessfulPopUpState();
}

class _PaymentSuccessfulPopUpState extends State<PaymentSuccessfulPopUp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 6),
      () {
        Navigator.pushAndRemoveUntil(context,
            SlideTransitionRouter.toNextPage(HomeScreen()), (route) => false);
      },
    );
    Hive.box("cart_box").put("cart", []);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
            height: 340,
            width: MediaQuery.sizeOf(context).width - 100,
            decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      "assets/payment_successful/payment_successful_popup_bg.svg",
                    ),
                    const Material(
                      child: Text(
                        "Order Placed Successfully!",
                        style: TextStyle(
                          color: Color(0xff121212),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12)
                  ],
                ),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              LottieBuilder.asset(
                "assets/payment_successful/payment_successful_popup.json",
                fit: BoxFit.fitHeight,
                repeat: false,
              )
            ],
          ),
        )
      ],
    );
  }
}
