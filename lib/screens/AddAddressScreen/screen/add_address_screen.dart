import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  Map<String, List> statesAndCities = {
    "Maharashtra": ["d", "d"],
    "Goa": ["d", "d", "d"],
  };

  List<DropdownMenuEntry> citesOfChoosenState = [];

  List<DropdownMenuEntry> addressTypes = [
    const DropdownMenuEntry(value: "Home", label: "Home"),
    const DropdownMenuEntry(value: "Work", label: "Work"),
    const DropdownMenuEntry(value: "Other", label: "Other"),
  ];

  TextEditingController houseNumberController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressTypeController = TextEditingController();

  late List<DropdownMenuEntry> stateEntries = [];

  void saveAddress() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statesAndCities.forEach((key, value) {
      stateEntries.add(DropdownMenuEntry(value: key, label: key));
    });
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
          "Add New Address",
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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Icon(Icons.home, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        entryBox(houseNumberController, "House Number",
                            AutofillHints.streetAddressLine1),
                        const SizedBox(height: 24),
                        entryBox(streetController, "Street / Block",
                            AutofillHints.streetAddressLine2),
                        const SizedBox(height: 24),
                        dropDownMenu("State", stateEntries, stateController),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Flexible(
                              child: entryBox(
                                pincodeController,
                                "Pincode",
                                AutofillHints.postalCode,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Flexible(
                              child: dropDownMenu(
                                "City",
                                citesOfChoosenState,
                                cityController,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        dropDownMenu("Address Type", addressTypes,
                            addressTypeController),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
              saveAddressButton(saveAddress),
            ],
          ),
        ),
      ),
    );
  }
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
      labelText: label,
    ),
  );
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
    dropdownMenuEntries: dropDownMenuEntries,
    controller: controller,
    requestFocusOnTap: true,
    label: Text(label),
    expandedInsets: EdgeInsets.zero,
  );
}

Widget saveAddressButton(Function onpress) {
// Returns the saveAddress button on top of the page, takes in an onPress function
// which is called when the button is pressed.
  return InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: onpress(),
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
              "Save Address",
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
