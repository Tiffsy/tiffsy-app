import "package:flutter/material.dart";

class BillingSummaryScreen extends StatefulWidget {
  const BillingSummaryScreen({super.key});

  @override
  State<BillingSummaryScreen> createState() => _BillingSummaryScreenState();
}

class _BillingSummaryScreenState extends State<BillingSummaryScreen> {
  TextEditingController couponCodeController = TextEditingController();
  late Map<String, double> summaryBreakdown;
  late double grandTotal;

  Map<String, double> getSummaryBreakdown() {
    // return map for the type of amount as the key (case sensitive) and the amount
    // as the value. Also all te values will be added up later so if they need to be
    // substracted then they should be negative, when displaying the sign will be
    // ignored.
    return {
      "Subtotal": 1000.33,
      "Discount": -285.36,
      "Shipping": 0,
      "GST": 420.69
    };
  }

  double calculateTotal(Map<String, double> summaryBreakdown) {
    double grandTotal = 0;
    summaryBreakdown.forEach((key, value) {
      grandTotal += value;
    });
    return grandTotal;
  }

  void clearCouponButton() {
    couponCodeController.clear();
  }

  List<String> getlistOfCoupons() {
    return ["FIRST", "NOFOOD", "OKAY"];
  }

  void proceedButtonOnPress() {}
  @override
  void initState() {
    super.initState();
    summaryBreakdown = getSummaryBreakdown();
    grandTotal = calculateTotal(summaryBreakdown);
  }

  @override
  Widget build(BuildContext context) {
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
            // go back functionality, most likely using Navigator.pop()
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
              children: billingInformation(summaryBreakdown, grandTotal) +
                  couponEntryBox(couponCodeController, getlistOfCoupons(),
                      clearCouponButton) +
                  proceedButton(proceedButtonOnPress)),
        ),
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

List<Widget> couponEntryBox(TextEditingController couponTextEditingController,
    List<String> listOfcoupons, Function clearAll) {
  return [
    const SizedBox(height: 28),
    TextFormField(
      controller: couponTextEditingController,
      validator: (value) {
        return (listOfcoupons.contains(value) ? "Applied Successfully" : null);
      },
      maxLines: 1,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 24 / 16,
      ),
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 56),
        suffixIcon: couponTextEditingController.text.isEmpty
            ? Container()
            : IconButton(
                color: const Color(0xff121212),
                onPressed: () {
                  clearAll();
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 24,
                ),
              ),
        labelText: "COUPON",
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0x66121212),
          height: 24 / 16,
        ),
      ),
    )
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
