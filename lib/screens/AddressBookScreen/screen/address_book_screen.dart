import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:tiffsy_app/screens/AddAddressScreen/screen/add_address_screen.dart";
import "package:tiffsy_app/screens/AddressBookScreen/bloc/address_book_bloc.dart";
import "package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart";
import "package:tiffsy_app/screens/HomeScreen/bloc/home_bloc.dart";
import "package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart";
import "package:tiffsy_app/screens/ProfileScreen/screen/profile_screen.dart";

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBookBloc()..add(AddressBookInitialFetchEvent()),
      child: Scaffold(
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
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAddressScreen()));
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
        body: BlocConsumer<AddressBookBloc, AddressBookState>(
          listener: (context, state) {
            if (state is AddressBookErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is AddAddressButtonClickedState) {
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAddressScreen()));
        
            }
          },
          builder: (context, state) {
            if (state is AddressListFetchSuccessState) {
              final addressListState = state;
              return Column(
                children: [
                  addAddressButton(() {
                    BlocProvider.of<AddressBookBloc>(context).add(AddressBookAddAdresssButtonClickedEvent());
                  }),
                  listOfAddressCards(addressListState.addressList),
                ],
              );
            } 
            else if (state is AddressBookLoadingState){
              return Center(child: CircularProgressIndicator());
            }
            else {
              return Center(child: Text("Error While loading page"));
            }
          },
        ),
      ),
    );
  }
}

Widget addAddressButton(VoidCallback onpress) {
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
    child: ElevatedButton(
      onPressed: onpress,
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

Widget listOfAddressCards(List<AddressDataModel> listOfAddress) {
// Returns a list of addressCards arranged in a column and a scrollView to be
// placed directly into the body of addressBookScreen
  List<Widget> listOfAddressCardsFromAddresses = [];
  for (int i = 0; i < listOfAddress.length; i++) {
    listOfAddressCardsFromAddresses.add(
      addressCard(listOfAddress[i].addrType, listOfAddress[i].addLine1),
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
