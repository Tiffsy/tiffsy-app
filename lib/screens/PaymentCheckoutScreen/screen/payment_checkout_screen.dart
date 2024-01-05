import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiffsy_app/screens/PaymentCheckoutScreen/bloc/payment_checkout_bloc.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key, required this.amount});
  final double amount;

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  PaymentCheckoutBloc paymentCheckoutBloc = PaymentCheckoutBloc();

  void googlePayUpi(String orderID, double amount) {
    print("okayy");
    paymentCheckoutBloc
        .add(GooglePayUPIEvent(orderID: orderID, amount: amount));
  }

  void paytmUpi() {}

  void upiId() {}

  void creditOrDebitCard() {}

  void paytmWallet() {}

  void phonePeWallet() {}

  void mobiKwikWallet() {}

  void netBanking() {}

  void callPaymentMethod(String paymentMethod) {
    switch (paymentMethod) {
      case "Google Pay":
        googlePayUpi("sufgvuldsv", widget.amount);
      case "Paytm UPI":
        paytmUpi();
      case "UPI ID":
        upiId();
      case "Add Credit / Debit card":
        creditOrDebitCard();
      case "Paytm":
        paytmWallet();
      case "PhonePe":
        phonePeWallet();
      case "Mobikwik":
        mobiKwikWallet();
      case "Netbanking":
        netBanking();
        break;
      default:
    }
  }

  List upiBasedPayements = [
    {
      "title": "Google Pay",
      "image":
          "assets/images/vectors/payment_checkout_screen/google_pay_logo.svg"
    },
    {
      "title": "Paytm UPI",
      "image": "assets/images/vectors/payment_checkout_screen/paytm_wallet.svg"
    },
    {
      "title": "UPI ID",
      "image": "assets/images/vectors/payment_checkout_screen/upi_logo.svg"
    }
  ];

  List cardBasedPayements = [
    {
      "title": "Add Credit / Debit card",
      "image":
          "assets/images/vectors/payment_checkout_screen/credit_or_debit_card.svg"
    }
  ];

  List walletBasedPayments = [
    {
      "title": "Paytm",
      "image": "assets/images/vectors/payment_checkout_screen/paytm_wallet.svg"
    },
    {
      "title": "PhonePe",
      "image":
          "assets/images/vectors/payment_checkout_screen/phonepe_wallet.svg"
    },
    {
      "title": "Mobikwik",
      "image":
          "assets/images/vectors/payment_checkout_screen/mobikwik_wallet.svg"
    }
  ];

  List otherPayments = [
    {
      "title": "Netbanking",
      "image": "assets/images/vectors/payment_checkout_screen/net_banking.svg"
    }
  ];

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
            Navigator.pop(context);
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              totalBillCard(widget.amount),
              paymentTypetext("UPI"),
              paymentsOptionButton(upiBasedPayements, callPaymentMethod),
              paymentTypetext("Cards"),
              paymentsOptionButton(cardBasedPayements, callPaymentMethod),
              paymentTypetext("Wallets"),
              paymentsOptionButton(walletBasedPayments, callPaymentMethod),
              paymentTypetext("Others"),
              paymentsOptionButton(otherPayments, callPaymentMethod)
            ],
          ),
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

Widget paymentsOptionButton(
    List paymentOptions, Function(String) paymentOptionOnTap) {
  List<Widget> listOfPaymentOptions = [];

  if (paymentOptions.length == 1) {
    listOfPaymentOptions.add(
      Expanded(
        child: InkWell(
          onTap: () {
            paymentOptionOnTap(paymentOptions[0]["title"]);
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              sizedLogoInContainer(paymentOptions[0]["image"]),
              const SizedBox(width: 14),
              Text(
                paymentOptions[0]["title"],
                style: const TextStyle(
                    color: Color(0xff121212),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
              const SizedBox(width: 14)
            ],
          ),
        ),
      ),
    );
  } else {
    for (int i = 0; i < paymentOptions.length; i++) {
      if (i == 0) {
        listOfPaymentOptions.add(
          Expanded(
            child: InkWell(
              onTap: () {
                paymentOptionOnTap(paymentOptions[0]["title"]);
              },
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  sizedLogoInContainer(paymentOptions[0]["image"]),
                  const SizedBox(width: 14),
                  Text(
                    paymentOptions[0]["title"],
                    style: const TextStyle(
                        color: Color(0xff121212),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 14)
                ],
              ),
            ),
          ),
        );
        listOfPaymentOptions.add(
          const Divider(
            thickness: 1,
            height: 1,
            indent: 12,
            endIndent: 12,
            color: Color(0x33121212),
          ),
        );
      } else if (i == paymentOptions.length - 1) {
        listOfPaymentOptions.add(
          Expanded(
            child: InkWell(
              onTap: () {
                paymentOptionOnTap(paymentOptions[i]["title"]);
              },
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  sizedLogoInContainer(paymentOptions[i]["image"]),
                  const SizedBox(width: 14),
                  Text(
                    paymentOptions[i]["title"],
                    style: const TextStyle(
                        color: Color(0xff121212),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 14)
                ],
              ),
            ),
          ),
        );
      } else {
        listOfPaymentOptions.add(
          Expanded(
            child: InkWell(
              onTap: () {
                paymentOptionOnTap(paymentOptions[i]["title"]);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  sizedLogoInContainer(paymentOptions[i]["image"]),
                  const SizedBox(width: 14),
                  Text(
                    paymentOptions[i]["title"],
                    style: const TextStyle(
                        color: Color(0xff121212),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 14)
                ],
              ),
            ),
          ),
        );
        listOfPaymentOptions.add(
          const Divider(
            thickness: 1,
            height: 1,
            indent: 12,
            endIndent: 12,
            color: Color(0x33121212),
          ),
        );
      }
    }
  }

  return Container(
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0x33121212)),
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    height: paymentOptions.length * 44,
    child: Column(
      children: listOfPaymentOptions,
    ),
  );
}

Widget sizedLogoInContainer(String filePath) {
  return Container(
    height: 20,
    width: 28,
    decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: const Color(0x33121212)),
        borderRadius: const BorderRadius.all(Radius.circular(4))),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: SvgPicture.asset(
          filePath,
          theme: const SvgTheme(currentColor: Colors.black),
        ),
      ),
    ),
  );
}

Widget paymentTypetext(String paymentType) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Text(
      paymentType,
      style: const TextStyle(
          color: Color(0xff121212),
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w500),
    ),
  );
}
