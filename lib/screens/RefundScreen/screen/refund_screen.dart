import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tiffsy_app/Helpers/loading_animation.dart';
import 'package:tiffsy_app/screens/RefundScreen/bloc/refund_bloc.dart';
import 'package:tiffsy_app/screens/RefundScreen/model/refund_data_model.dart';

class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Refund History",
          style: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff121212),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => RefundBloc()..add(RefundInitialFetchEvent()),
        child: BlocConsumer<RefundBloc, RefundState>(
          listener: (context, state) {

          },
          builder: (context, state) {
            if (state is RefundHistoryFetchError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is RefundHistoryFetchLoading) {
              return LoadingAnimation.circularLoadingAnimation(context);
            } else if (state is RefundHistoryFetchSuccess) {
              return state.refundList.isEmpty
                  ? LoadingAnimation.emptyDataAnimation(
                      context, "No Refund Till Now!")
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                                const SizedBox(height: 12),
                              ] +
                              listOfPaymentHistoryCards(
                                  context, state.refundList),
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
      BuildContext context, List<RefundDataModel> listOfdataModel) {
    List<Widget> listOfWidget = [];
    for (var element in listOfdataModel) {
      listOfWidget.addAll([
        singlePaymentHistoryCard(context, element),
        const SizedBox(height: 24)
      ]);
    }
    return listOfWidget;
  }

  Widget singlePaymentHistoryCard(BuildContext context, RefundDataModel data) {
    DateTime dateTime = DateTime.parse(data.refundDate);
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
                  "Refund ID",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: 0.10,
                  ),
                ),
                Spacer(),
                Text(
                  data.rfndId,
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 14,
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
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
                Spacer(),
                Text(
                  data.refundAmount.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
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
                  "Status",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
                Spacer(),
                Text(
                  data.status.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
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
                  "Status",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
                Spacer(),
                Text(
                  data.subscriptionId.toString(),
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
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
                  "Refund Date",
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
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
