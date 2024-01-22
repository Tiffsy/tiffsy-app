import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tiffsy_app/Helpers/loading_animation.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/screens/CalendarScreen/screen/calendar_screen.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/bloc/subscription_home_page_bloc.dart';
import 'package:tiffsy_app/screens/SubscriptionHomePageScreen/model/subscription_page_model.dart';

class SubscriptionHomePageScreen extends StatefulWidget {
  const SubscriptionHomePageScreen({super.key});

  @override
  State<SubscriptionHomePageScreen> createState() =>
      _SubscriptionHomePageScreenState();
}

class _SubscriptionHomePageScreenState
    extends State<SubscriptionHomePageScreen> {
  String getSubscriptionLength(String subType) {
    return '$subType Day Subscription';
  }

  DateTime getLastDeliveryDate() {
    return DateTime.now();
  }

  int calculateDifferenceInDays(DateTime dateTime1, DateTime dateTime2) {
    Duration difference = dateTime2.difference(dateTime1);
    return difference.inDays.abs(); // Return the absolute difference in days
  }

  int getRemainingDaysQuantity(String strDt, String enddt) {
    DateTime st = DateTime.parse(strDt);
    DateTime et = DateTime.parse(enddt);

    DateTime cur = DateTime.now();

    if (cur.isBefore(st))
      return -1;
    else if (et.isBefore(cur)) return 0;

    return calculateDifferenceInDays(et, cur);
  }

  List<SubscriptionDataModel> subcriptionList = [];
  List<Widget> subsCard = [];

  @override
  Widget build(BuildContext context) {
    // This only returns the body which is used in the scaffold of the HomeScreen()
    return BlocProvider(
      create: (context) =>
          SubscriptionHomePageBloc()..add(SubcriptionInitialFetchEvent()),
      child: BlocConsumer<SubscriptionHomePageBloc, SubscriptionHomePageState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is SubscriptionPageLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SubscriptionFetchSuccessState) {
            subcriptionList = state.subcriptionList;
            subsCard = [];
            for (int index = 0; index < subcriptionList.length; index++) {
              subsCard.add(subscriptionCard(subcriptionList[index].subtype, () {
                Navigator.push(
                    context,
                    SlideTransitionRouter.toNextPage(CalendarScreen(
                        cstId: subcriptionList[index].cstId,
                        subsId: subcriptionList[index].sbcrId)));
              }, subcriptionList[index].endDt, subcriptionList[index].addrLine,
                  subcriptionList[index].strDt));
            }
          }
          return (subsCard.isEmpty)
              ? LoadingAnimation.subscriptionEmptyAnimation(
                  context, "No Active Subscription!")
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                          const SizedBox(height: 24),
                          const Text(
                            'Current Subscription',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              letterSpacing: 0.15,
                            ),
                          )
                        ] +
                        subsCard,
                  ),
                );
        },
      ),
    );
  }

  Widget subscriptionCard(int subType, Function cancelOrder, String enddt,
      String addr, String strDt) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            height: 99,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x1EFFBE1D),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      getSubscriptionLength(subType.toString()),
                      style: const TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        letterSpacing: 0.10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$addr',
                      style: const TextStyle(
                        color: Color(0xFF323232),
                        fontSize: 11,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 16 / 11,
                        letterSpacing: 0.50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        cancelOrder();
                      },
                      child: Container(
                        height: 23,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFD39B0D)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          child: Text(
                            'Cancel upcoming orders',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFD39B0D),
                              fontSize: 11,
                              height: 1,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 13),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            getRemainingDaysQuantity(strDt, enddt) == -1
                                ? "Subscription haven't started yet"
                                : '${getRemainingDaysQuantity(strDt, enddt)} Days remaining',
                            style: const TextStyle(
                              color: Color(0xFFF84545),
                              fontSize: 11,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 16 / 11,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}