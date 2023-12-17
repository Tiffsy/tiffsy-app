import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  // test data ;)
  List<Map<String, String>> listOfAddress() {
    // This function should get the addresses and return them in the format:
    // [
    //   {
    //     "adressType": "Work",
    //     "address":
    //         "House no. 108, Keshav Nagar, in front of Grand Arc Apartments, Pune"
    //   },
    //   {
    //     "addressType": "Home",
    //     "address":
    //         "House no. 108, Keshav Nagar, in front of Grand Arc Apartments, Pune"
    //   },
    // ];

    return [
      {
        "addressType": "Work",
        "address":
            "House no. 108, Keshav Nagar, in front of Grand Arc Apartments, Pune"
      },
      {
        "addressType": "Home",
        "address":
            "House no. 108, Keshav Nagar, in front of Grand Arc Apartments, Pune"
      },
      {
        "addressType": "Other",
        "address":
            "House no. 108, Keshav Nagar, in front of Grand Arc Apartments, Pune"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color(0xffffffff),
        surfaceTintColor: const Color(0xffffffff),
        leadingWidth: 64,
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
          "Address Book",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff121212)),
        ),
      ),
      body: Column(
        children: [
          addAddressButton(() {}),
          listOfAddressCards(listOfAddress()),
        ],
      ),
    );
  }
}

Widget addAddressButton(Function onpress) {
// Returns the addAddress button on top of the page, takes in an onPress function
// which is called when the button is pressed.

  Widget buttonText = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.add,
        size: 18,
        color: Color(0xff121212),
      ),
      SizedBox(width: 8),
      Text(
        "Add address",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xff121212),
          height: 1.5,
        ),
      ),
    ],
  );
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        onpress;
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
    ),
  );
}

Widget listOfAddressCards(List<Map<String, dynamic>> listOfAddress) {
// Returns a list of addressCards arranged in a column and a scrollView to be
// placed directly into the body of addressBookScreen.

  List<Widget> listOfAddressCardsFromAddresses = [];
  for (int i = 0; i < listOfAddress.length; i++) {
    listOfAddressCardsFromAddresses.add(
      addressCard(listOfAddress[i]["addressType"], listOfAddress[i]["address"]),
    );
  }
  return Flexible(
    child: SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(children: listOfAddressCardsFromAddresses),
    ),
  );
}

Widget addressCard(String addressType, String address) {
  // Returns a card arranging the provided information in the format specified,
  // automatically deciding what icon (home or work) to apply based on the isWork value.

  IconData addressTypeIcon = Icons.home;
  if (addressType == "Work") {
    addressTypeIcon = Icons.work;
  } else if (addressType == "Home") {
    addressTypeIcon = Icons.home;
  } else {
    addressTypeIcon = Icons.language_rounded;
  }

  Widget addressTypeData = Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        addressTypeIcon,
        size: 24,
        color: const Color(0xffffbe1d),
      ),
      const SizedBox(width: 12),
      Text(
        addressType,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xff121212),
          height: 1.5,
        ),
      ),
    ],
  );

  Widget addressText = Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(width: 36),
      Flexible(
        child: Text(
          address,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 4 / 3,
          ),
        ),
      ),
      const SizedBox(width: 26)
    ],
  );

  Widget arrowButton = Stack(
    alignment: Alignment.center,
    children: [
      SvgPicture.asset(
        "assets/images/vectors/address_book_screen/Ellipse 52.svg",
      ),
      SvgPicture.asset(
        "assets/images/vectors/address_book_screen/ion_arrow-redo-outline.svg",
      ),
    ],
  );

  Widget addressActionsButtons = Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      arrowButton,
      const SizedBox(width: 8),
      SvgPicture.asset(
        "assets/images/vectors/address_book_screen/ph_dots-three-circle-light.svg",
        height: 24,
        width: 24,
      ),
    ],
  );

  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xfffffcef),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            addressTypeData,
            const SizedBox(height: 8),
            addressText,
            const SizedBox(height: 8),
            addressActionsButtons
          ],
        ),
      ),
    ),
  );
}
