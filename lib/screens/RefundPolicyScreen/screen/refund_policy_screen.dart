import 'package:flutter/material.dart';

class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({super.key});

  @override
  State<RefundPolicyScreen> createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen> {
  void contactUsOnPress() {
    // What to do when user presses contact us!
  }

  List<String> getPolicyPoints() {
    return [
      "Customers can opt for a refund at any point of time during his/her subscription period, the same day, applicable refund will be initiated.",
      "If a customer chooses not to take a meal during the subscription period, he has to confirm on app, before the freeze period of that meal.",
      "No refund will be given for a meal, after the freeze period(2-3 hrs before delivery) has started.",
      "Same day orders will not be cancelled/refunded.",
      "If a user chooses to upgrade his meal, only the balance amount will be taken, ensuring same day settlement.",
      "One time upgraded/downgraded meal cannot be changed again.",
      "If a user chooses to downgrade his meal, the amount will be refunded at the end of subscription. In case of continued subscription, the amount will be adjusted on payment.",
    ];
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
          "Refund Policy",
          style: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff121212),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: addContactUsButton(
                contactUsOnPress, listOfTextCards(getPolicyPoints())),
          ),
        ),
      ),
    );
  }
}

List<Widget> addContactUsButton(
    Function onPress, List<Widget> listOfTextCards) {
  listOfTextCards.add(const SizedBox(height: 16));
  listOfTextCards.add(
    const Text(
      "Have any query?",
      style: TextStyle(
        color: Color(0xff121212),
        fontSize: 14,
        fontFamily: "Inter",
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.1,
      ),
    ),
  );
  listOfTextCards.add(const SizedBox(height: 12));
  listOfTextCards.add(contactUsButton(onPress));
  listOfTextCards.add(const SizedBox(height: 44));
  return listOfTextCards;
}

List<Widget> listOfTextCards(List<String> policyPoints) {
  List<Widget> listOfTextCards = [const SizedBox(height: 10)];
  for (String element in policyPoints) {
    listOfTextCards.add(singleTextcard(element));
    listOfTextCards.add(const SizedBox(height: 16));
  }
  return listOfTextCards;
}

Widget contactUsButton(Function onPress) {
  return InkWell(
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
              "Contact Us",
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
  );
}

Widget singleTextcard(String text) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: const Color(0xfffffcef),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•"),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xff121212),
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
