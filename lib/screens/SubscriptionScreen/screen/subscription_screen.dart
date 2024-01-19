import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/screens/BillingSumaryScreen/screen/billing_summary_screen.dart';
import 'package:tiffsy_app/screens/SubscriptionScreen/bloc/subscription_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key, required this.noOfDays});
  final int noOfDays;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String subscriptionLength(int noOfDays) {
    switch (noOfDays) {
      case 1:
        return "One Day Meal";
      case 7:
        return "Weekly Subscription";
      case 15:
        return "15 Day Subscription";
      case 30:
        return "Monthly Subscription";
      default:
        return "Subscription";
    }
  }

  Box cartBox = Hive.box("cart_box");
  TextEditingController subscriptionNameController = TextEditingController();
  TextEditingController instructionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  @override
  Widget build(BuildContext context) {
    int breakfastCount = cartBox.get("Breakfast", defaultValue: 0);
    int lunchCount = cartBox.get("Lunch", defaultValue: 0);
    int dinnerCount = cartBox.get("Dinner", defaultValue: 0);
    bool isSubscription = cartBox.get("is_subscription");

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
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
        title: Text(
          subscriptionLength(widget.noOfDays),
          style: const TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff121212),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 154,
                width: MediaQuery.sizeOf(context).width - 40,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFFCEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 24, top: 16, bottom: 8),
                      child: Text(
                        'Time Period',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                    const Divider(height: 0, thickness: 1),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        Flexible(
                          child: GestureDetector(
                            onTap: () async {
                              startDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 100),
                                ),
                              );
                              if (startDate != null) {
                                endDate = startDate!
                                    .add(Duration(days: widget.noOfDays));
                                String startDateText =
                                    DateFormat('dd/MM/yyyy').format(startDate!);
                                String endDateText =
                                    DateFormat('dd/MM/yyyy').format(endDate!);
                                setState(() {
                                  startDateController.text = startDateText;
                                  endDateController.text = endDateText;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: dateEntryBox(
                                isSubscription ? "Start Date" : "Delivery Date",
                                startDateController,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isSubscription ? 12 : 0),
                        isSubscription
                            ? Flexible(
                                child: GestureDetector(
                                  child: AbsorbPointer(
                                    child: dateEntryBox(
                                      "End date",
                                      endDateController,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topCenter,
                height: 270,
                width: MediaQuery.sizeOf(context).width - 40,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFFCEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Icon(Icons.food_bank, size: 24),
                    const SizedBox(height: 20),
                    const Text(
                      'Time corresponding to the meal is tentative.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                      ),
                    ),
                    const SizedBox(height: 16),
                    cartSummaryList(
                      breakfastCount,
                      lunchCount,
                      dinnerCount,
                      context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.sizeOf(context).width - 40,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFFCEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 24, top: 16, bottom: 8),
                      child: Text(
                        'Add Nore Details (Optional)',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, height: 0),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: entryBox(subscriptionNameController,
                          "Subscription name", null),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child:
                          entryBox(instructionController, "Instructions", null),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              proceedToCheckOutButton(
                () async {
                  if (startDate != null && endDate != null) {
                    cartBox
                        .putAll({"start_date": startDate, 'end_date': endDate});
                    Navigator.push(
                        context,
                        SlideTransitionRouter.toNextPage(
                            BillingSummaryScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please choose start date")));
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dateEntryBox(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 24 / 16,
    ),
    decoration: InputDecoration(
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0x66121212),
        height: 24 / 16,
      ),
    ),
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
          cartSummaryEntry("Breakfast", "9:00 AM", breakfast),
          const Divider(height: 0, thickness: 1),
          cartSummaryEntry("Lunch", "2:00 PM", lunch),
          const Divider(height: 0, thickness: 1),
          cartSummaryEntry("Dinner", "7:00 PM", dinner)
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
              fontFamily: 'Roboto',
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
          fontFamily: 'Roboto',
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
          fontFamily: 'Roboto',
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

Widget entryBox(
    TextEditingController controller, String label, String? autofillHints) {
  Iterable<String>? autoFill = autofillHints == null ? {} : {autofillHints};
  return TextFormField(
    autofillHints: autoFill,
    controller: controller,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 24 / 16,
    ),
    decoration: InputDecoration(
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffFFBE1D)),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0x66121212),
        height: 24 / 16,
      ),
    ),
  );
}

Widget proceedToCheckOutButton(VoidCallback onpress) {
  Widget buttonText = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      Text(
        "Proceed To Checkout",
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
