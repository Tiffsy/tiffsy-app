import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tiffsy_app/Helpers/loading_animation.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/bloc/payment_history_bloc.dart';
import 'package:tiffsy_app/screens/PaymentHistoryScreen/model/payment_history_model.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  PaymentHistoryBloc paymentHistoryBloc = PaymentHistoryBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentHistoryBloc.add(PaymentHistoryInitialFetchEvent());
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff121212),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => paymentHistoryBloc,
        child: BlocConsumer<PaymentHistoryBloc, PaymentHistoryState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is PaymentHistoryInitialFetchLoadingState) {
              return LoadingAnimation.circularLoadingAnimation(context);
            } else if (state is PaymentHistoryInitialFetchFailedState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Error Occured")));
            } else if (state is PaymentHistoryInitialFetchSuccessfulState) {
              return state.listOfPaymentHistoryDataModel.isEmpty
                  ? LoadingAnimation.emptyDataAnimation(
                      context, "No Transactions Made Till Now!")
                  : SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                                const SizedBox(height: 12),
                              ] +
                              listOfPaymentHistoryCards(
                                  context, state.listOfPaymentHistoryDataModel),
                        ),
                      ),
                  );
            }
            return LoadingAnimation.subscriptionEmptyAnimation(
                context, "An Error Occured");
          },
        ),
      ),
    );
  }

  List<Widget> listOfPaymentHistoryCards(
      BuildContext context, List<PaymentHistoryDataModel> listOfdataModel) {
    List<Widget> listOfWidget = [];
    for (var element in listOfdataModel) {
      listOfWidget.addAll([
        singlePaymentHistoryCard(context, element),
        const SizedBox(height: 24)
      ]);
    }
    return listOfWidget;
  }

  Widget singlePaymentHistoryCard(
      BuildContext context, PaymentHistoryDataModel data) {
    DateTime dateTime = DateTime.parse(data.paymentDate);
    return Container(
      width: MediaQuery.sizeOf(context).width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xfffffcef)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Transaction ID",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: 0.10,
                  ),
                ),
                Spacer(),
                Text(
                  data.trnId,
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            Row(
              children: [
                const Text(
                  "Amount",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
                Spacer(),
                Text(
                  data.paymentAmount.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            Row(
              children: [
                const Text(
                  "Payment Date",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat('d MMM yyyy \'at\' h:mma').format(dateTime),
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
