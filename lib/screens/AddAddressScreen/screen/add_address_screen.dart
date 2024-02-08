import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tiffsy_app/Helpers/loading_animation.dart';
import 'package:tiffsy_app/screens/AddAddressScreen/bloc/add_address_screen_dart_bloc.dart';
import 'package:tiffsy_app/screens/AddressBookScreen/bloc/address_book_bloc.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, required this.onAdd});
  final Function onAdd;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  Map<String, List> statesAndCities = {
    "Maharashtra": ["Pune"],
  };
  List<String> pincodes = ["306308","411006","411028","411036","451224"];

  // populate this list based on the state selected
  List<DropdownMenuEntry> citesOfChoosenState = [
     const DropdownMenuEntry(value: "Pune", label: "Pune"),
  ];
  
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

  @override
  void initState() {
    super.initState();
    statesAndCities.forEach((key, value) {
      stateEntries.add(
        DropdownMenuEntry(
          value: key,
          label: key,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAddressScreenDartBloc(),
      child: Scaffold(
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
        body: BlocConsumer<AddAddressScreenDartBloc, AddAddressScreenDartState>(
          listener: (context, state) {
            if (state is AddAddressErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is AddAddressSuccessState) {
              Navigator.pop(context);
              widget.onAdd();
            }
          },
          builder: (context, state) {
            if (state is AddAddressLoadingState) {
              return Center(
                child: LoadingAnimation.circularLoadingAnimation(context),
              );
            }
            return Padding(
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
                              dropDownMenu(
                                  "State", stateEntries, stateController),
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
                    saveAddressButton(
                      () {
                        if(houseNumberController.text.isEmpty || stateController.text.isEmpty 
                        || streetController.text.isEmpty || cityController.text.isEmpty || addressTypeController.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                          content: Text("All fields are mandatory.")));
                        }
                        else if(!pincodes.contains(pincodeController.text)){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Color(0xffFFBE1D),
                            content: Text("Outside the service coverage", style: TextStyle(color: Colors.black),)));
                        }
                        else{
                           BlocProvider.of<AddAddressScreenDartBloc>(context).add(
                          SaveAddressClicked(
                            cst_id: Hive.box('customer_box')
                                .get('cst_id')
                                .toString(),
                            add_id: "5",
                            house_num: houseNumberController.text,
                            addr_line: streetController.text,
                            state: stateController.text,
                            pin: pincodeController.text,
                            city: cityController.text,
                            addr_type: addressTypeController.text,
                            contact: "9530077899",
                          ),
                        );
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    const Text("• All fields are mandatory",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),)
                  ],
                ),
              ),
            );
          },
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
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0x66121212),
        height: 24 / 16,
      ),
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

Widget saveAddressButton(Function onPress) {
// Returns the saveAddress button on top of the page, takes in an onPress function
// which is called when the button is pressed.
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
