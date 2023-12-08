import 'package:flutter/material.dart';

class FrequentlyAskedQuestionsScreen extends StatefulWidget {
  const FrequentlyAskedQuestionsScreen({super.key});

  @override
  State<FrequentlyAskedQuestionsScreen> createState() =>
      _FrequentlyAskedQuestionsScreenState();
}

class _FrequentlyAskedQuestionsScreenState
    extends State<FrequentlyAskedQuestionsScreen> {
  Map<String, String> getFAQs() {
    // This function will return a Map of QnA's, in the form of:
    // {"question":"answer"}, for now we will return a test Map
    return {
      "How does Tiffy work?":
          "Tiffsy is a convenient tiffin delivery app that connects you with talented home chefs. Simply download the app, sign up, and choose your meal preferences. Our chefs will prepare delicious homemade meals, and we'll deliver them to your doorstep at the scheduled times.",
      "What meal options do you offer?":
          "If you're visiting this page, you're likely here because you're searching for a random sentence. Sometimes a random word just isn't enough, and that is where the random sentence generator comes into play. By inputting the desired number, you can make a list of as many random sentences as you want or need. Producing random sentences can be helpful in a number of different ways.",
      "Can I customise my meals based on dietary preferences or restrictions?":
          "For writers, a random sentence can help them get their creative juices flowing. Since the topic of the sentence is completely unknown, it forces the writer to be creative when the sentence appears. There are a number of different ways a writer can use the random sentence for creativity. The most common way to use the sentence is to begin a story. Another option is to include it somewhere in the story. A much more difficult challenge is to use it to end a story. In any of these cases, it forces the writer to think creatively since they have no idea what sentence will appear from the tool.",
    };
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
          "Frequently Asked Questions",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff121212)),
        ),
      ),
      body: listOfFaqs(getFAQs()),
    );
  }
}

Widget listOfFaqs(Map<String, String> faqs) {
  List<Widget> listOfFaqExpansionTile = [];
  faqs.forEach((question, answer) {
    listOfFaqExpansionTile.add(singleFaqExpansionTile(question, answer));
    listOfFaqExpansionTile.add(const Divider(height: 0));
  });
  return Flexible(
      child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: listOfFaqExpansionTile),
    ),
  ));
}

Widget singleFaqExpansionTile(String question, String answer) {
  return ExpansionTile(
    shape: const Border(),
    tilePadding: EdgeInsets.zero,
    childrenPadding: EdgeInsets.zero,
    title: Text(
      question,
      style: const TextStyle(
        color: Color(0xff121212),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
      ),
    ),
    children: [
      Text(
        answer,
        style: const TextStyle(
          color: Color(0xff121212),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
        ),
      ),
      const SizedBox(height: 12)
    ],
  );
}
