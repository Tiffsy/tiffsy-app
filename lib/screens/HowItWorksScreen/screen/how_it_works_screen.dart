import 'package:flutter/material.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  Map<int, Map<String, String>> getInstructions() {
    return {
      1: {
        "stepNumber": "1",
        "heading": "Choose your plan:",
        "options": "1 day / 1 week / 15 days / 30 days / Weekdays dinner",
      },
      2: {
        "stepNumber": "2",
        "heading": "Choose your meals:",
        "options": "Breakfast / Lunch / Dinner",
        "warning": "Not applicable for weekdays dinner"
      },
      3: {
        "stepNumber": "3",
        "heading": "Choose meal type:",
        "options": "Mini / Full-pait",
        "warning": "Not applicable for breakfast"
      },
      4: {
        "stepNumber": "4",
        "heading": "Give us your delivery address",
      },
      5: {
        "stepNumber": "5",
        "heading": "Make payments",
      },
      6: {
        "stepNumber": "6",
        "heading": "Easily upgrade/downgrade your meal anytime",
      },
      7: {
        "stepNumber": "7",
        "heading":
            "Have some other plans for someday, no worries, just inform us timely",
      }
    };
  }

  @override
  Widget build(BuildContext context) {
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
            // go back functionality, most likely using Navigator.pop()
          },
        ),
        title: const Text(
          "How it works",
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
        child: listOfStepCards(getInstructions()),
      ),
    );
  }
}

Widget listOfStepCards(Map<int, Map<String, String>> instructions) {
  List<Widget> listOfStepCards = [const SizedBox(height: 16)];
  for (int i = 1; i <= instructions.length; i++) {
    listOfStepCards.add(
      singleStepcard(
        i,
        instructions[i]!["heading"]!,
        instructions[i]!["options"],
        instructions[i]!["warning"],
      ),
    );
    listOfStepCards.add(const SizedBox(height: 16));
  }
  return SingleChildScrollView(
    child: Column(children: listOfStepCards),
  );
}

Widget singleStepcard(
  int stepNumber,
  String heading,
  String? options,
  String? warning,
) {
  List<Widget> listOfInstructionData = [
    headingText(heading),
  ];
  if (options != null) {
    listOfInstructionData.add(const SizedBox(height: 10));
    listOfInstructionData.add(optionsText(options));
  }
  if (warning != null) {
    listOfInstructionData.add(const SizedBox(height: 10));
    listOfInstructionData.add(warningtext(warning));
  }

  return Container(
    decoration: const BoxDecoration(
      color: Color(0xfffffcef),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
        topLeft: Radius.circular(4),
        topRight: Radius.circular(8),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stepNumberBox(stepNumber),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 32, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listOfInstructionData,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget stepNumberBox(int stepNumber) {
  return Container(
    height: 24,
    width: 24,
    decoration: const BoxDecoration(
      color: Color(0xffffe5a3),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
    ),
    child: Center(
      child: Text(
        stepNumber.toString(),
        style: const TextStyle(
          fontFamily: "Inter",
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    ),
  );
}

Widget headingText(String heading) {
  return Row(
    children: [
      Flexible(
        child: Text(
          heading,
          style: const TextStyle(
              color: Color(0xff121212),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              letterSpacing: 0.1),
        ),
      ),
    ],
  );
}

Widget optionsText(String options) {
  return Row(
    children: [
      Flexible(
        child: Text(
          options,
          style: const TextStyle(
            color: Color(0xff121212),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
      ),
    ],
  );
}

Widget warningtext(String warning) {
  return Row(
    children: [
      Flexible(
        child: Text(
          warning,
          style: const TextStyle(
            color: Color(0xfff84545),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
          ),
        ),
      ),
    ],
  );
}
