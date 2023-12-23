import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:tiffsy_app/screens/OrderHistoryScreen/bloc/order_history_bloc.dart";
import "package:tiffsy_app/screens/OrderHistoryScreen/model/order_history_model.dart";

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderHistoryBloc orderHistoryBloc = OrderHistoryBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderHistoryBloc>(
      create: (context) =>
          OrderHistoryBloc()..add(OrderHistoryInitialFetchEvent()),
      child: Scaffold(
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
            "Order History",
            style: TextStyle(
              fontSize: 20,
              height: 28 / 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff121212),
            ),
          ),
        ),
        body: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is OrderHistoreLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderHistoryFetchSuccessfulState) {
              final List<OrderHistoryModel> orderhistoryState =
                  (state).orderHistory;

              return orderHistoryPageBody(orderhistoryState);
            }
            return const Text("Error state");
          },
        ),
      ),
    );
  }
}

Widget orderHistoryPageBody(List<OrderHistoryModel> orderhistory) {
  List<Widget> listOfScheduledOrders = [];
  List<Widget> listOfDeliveredOrders = [];
  DateTime now = DateTime.now();
  for (var element in orderhistory) {
    if (now.isAfter(element.deliveryDate)) {
      if (listOfDeliveredOrders.isEmpty) {
        listOfDeliveredOrders.addAll([
          const Padding(
            padding: EdgeInsets.only(
              top: 24,
            ),
            child: Text(
              "Past Orders",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 24 / 14,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(height: 16),
          singleOrderHistoryCard(element.toMap()),
        ]);
      } else {
        listOfDeliveredOrders.addAll([
          const SizedBox(height: 16),
          singleOrderHistoryCard(element.toMap())
        ]);
      }
    } else {
      if (listOfScheduledOrders.isEmpty) {
        listOfScheduledOrders.addAll([
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Text(
              "Upcoming Orders",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 24 / 14,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(height: 16),
          singleOrderHistoryCard(element.toMap())
        ]);
      } else {
        listOfScheduledOrders.addAll([
          const SizedBox(height: 16),
          singleOrderHistoryCard(element.toMap())
        ]);
      }
    }
  }
  List<Widget> finalList = listOfScheduledOrders + listOfDeliveredOrders;
  finalList.add(const SizedBox(height: 20));
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ListView.builder(
      itemCount: finalList.length,
      itemBuilder: (context, index) {
        return finalList[index];
      },
    ),
  );
}

Widget singleOrderHistoryCard(Map<String, dynamic> orderDetails) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xfffffcef),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              orderHistoryCardBoldText(
                  "${orderDetails["count"]} x ${orderDetails["dish"]}"),
              const Spacer(),
              mealTypeTag(
                orderDetails["mealType"],
              )
            ],
          ),
          orderHistoryCardDivider(),
          Row(
            children: [
              orderHistoryCardText("Subscription Detail"),
              const Spacer(),
              orderHistoryCardText(orderDetails["subscriptionType"]),
            ],
          ),
          orderHistoryCardDivider(),
          Row(
            children: [
              orderHistoryCardText(
                  formattedDateTime(orderDetails["deliveryDate"])),
              const Spacer(),
              orderHistoryCardText(
                  "Rs.${orderDetails["amount"].toStringAsFixed(2)}"),
            ],
          ),
          orderHistoryCardDivider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              orderHistoryCardBoldText("Rate"),
              const Spacer(),
              deliveryStatusTag(orderDetails["delivered"])
            ],
          ),
        ],
      ),
    ),
  );
}

// Helper functions to make the orderHistoryCard.

Text orderHistoryCardBoldText(String text) {
  // Returns the string as a Text widget with the bold formatting mentioned in the
  // design.
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
  );
}

Text orderHistoryCardText(String text) {
  // Returns the string as a Text widget with the non-bold formatting mentioned in the
  // design.
  return Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    ),
  );
}

Widget mealTypeTag(String mealType) {
  // Returns the meal type string placed in the tag like container as mentioned in the
  // design.
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: const Color(0xffffbe1d),
    ),
    width: 76,
    height: 28,
    child: Center(
      child: Text(
        mealType,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 16 / 11,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

Widget orderHistoryCardDivider() {
  // Returns a divider along the appropriate spacing as mentioned in the design.
  return const SizedBox(
    height: 24.4,
    child: Center(
      child: Divider(
        height: 0,
        thickness: 0.4,
        color: Color(0x33121212),
      ),
    ),
  );
}

String formattedDateTime(int millisecondsSinceEpoch) {
  // Takes in milliseconds since epoch and returns a string in the format described
  // in the design: "21 Nov 2023 at 6:20PM"
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  return DateFormat('d MMM yyyy \'at\' h:mma').format(dateTime);
}

Widget deliveryStatusTag(bool delivered) {
  return Container(
    height: 28,
    width: 76,
    decoration: BoxDecoration(
      border: Border.all(
        color: delivered ? const Color(0xff6aa64f) : const Color(0xfff84545),
        width: 1,
      ),
      color: delivered ? const Color(0xffcbffb3) : const Color(0xffffdddd),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Center(
      child: Text(
        delivered ? "Delivered" : "Scheduled",
        style: TextStyle(
          color: delivered ? const Color(0xff6aa64f) : const Color(0xfff84545),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 16 / 11,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}
