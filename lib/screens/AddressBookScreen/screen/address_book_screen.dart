import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:hive/hive.dart";
import "package:tiffsy_app/Helpers/loading_animation.dart";
import "package:tiffsy_app/Helpers/page_router.dart";
import "package:tiffsy_app/screens/AddAddressScreen/screen/add_address_screen.dart";
import "package:tiffsy_app/screens/AddressBookScreen/bloc/address_book_bloc.dart";
import "package:tiffsy_app/screens/AddressBookScreen/model/address_data_model.dart";

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  bool isEmpty = true;
  List<AddressDataModel> addressListState = [];

  void updateAddress() {
    // AddressBookBloc().add(AddressBookInitialFetchEvent());
    Box addressBox = Hive.box("address_box");
    List listOfAddressJsons = addressBox.get("list_of_address");
    addressListState = [];
    for (var element in listOfAddressJsons) {
      addressListState.add(AddressDataModel.fromJson(element));
    }
    setState(() {
      addressListState = addressListState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddressBookBloc()..add(AddressBookInitialFetchEvent()),
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
              Navigator.pop(context);
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
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is AddAddressButtonClickedState) {
              Navigator.push(
                  context,
                  SlideTransitionRouter.toNextPage(
                      AddAddressScreen(onAdd: updateAddress)));
            }
          },
          builder: (context, state) {
            if (state is AddressListFetchSuccessState) {
              addressListState = state.addressList;
              isEmpty = false;
            } else if (state is NoAddressAddedState) {
              isEmpty = true;
            } else if (state is AddressBookLoadingState) {
              return Center(
                  child: LoadingAnimation.circularLoadingAnimation(context));
            }
            return Column(
              children: [
                addAddressButton(() {
                  BlocProvider.of<AddressBookBloc>(context)
                      .add(AddressBookAddAdresssButtonClickedEvent());
                }),
                isEmpty
                    ? SizedBox(height: MediaQuery.sizeOf(context).width * 0.4)
                    : const SizedBox(),
                isEmpty
                    ? LoadingAnimation.emptyDataAnimation(
                        context, "No Addresses Found")
                    : listOfAddressCards(addressListState),
                const Text("• Choose default address on home screen",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),)
              ],
            );
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
    child: InkWell(
      onTap: () {
        onpress();
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

Widget listOfAddressCards(List<AddressDataModel> listOfAddress) {
// Returns a list of addressCards arranged in a column and a scrollView to be
// placed directly into the body of addressBookScreen
  List<Widget> listOfAddressCardsFromAddresses = [];
  for (AddressDataModel element in listOfAddress) {
    listOfAddressCardsFromAddresses.add(
      addressCard(element.addrType, element.houseNum, element.addrLine,
          element.city, element.state),
    );
  }
  if (listOfAddressCardsFromAddresses.isEmpty) {
    return const Center(child: Text("No Address Found"));
  }
  return Flexible(
    child: SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(children: listOfAddressCardsFromAddresses),
    ),
  );
}

Widget addressCard(String addressType, String houseNum, String addrLine,
    String city, String state) {
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
            addressText(houseNum),
            addressText(addrLine),
            addressText("$city, $state"),
            const SizedBox(height: 8),
            addressActionsButtons
          ],
        ),
      ),
    ),
  );
}

Widget addressText(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(width: 36),
      Flexible(
        child: Text(
          text,
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
}
