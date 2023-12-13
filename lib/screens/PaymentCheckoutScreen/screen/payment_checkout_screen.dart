import 'package:flutter/material.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key});

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
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
          "Payment",
          style: TextStyle(
              fontSize: 20,
              height: 28 / 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff121212)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [totalBillCard(200.78)],
        ),
      ),
    );
  }
}

Widget totalBillCard(double billAmount) {
  String amount = billAmount.toStringAsFixed(2);
  return Container(
    height: 40,
    decoration: BoxDecoration(
        color: const Color(0xffffe5a3), borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Text(
        "Bill Total Rs. $amount",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 24 / 16,
          letterSpacing: 0.15,
        ),
      ),
    ),
  );
}

//Widget setOfPaymentOptions(List<Map<String, dynamic>> listOfPaymentMethods){

//}