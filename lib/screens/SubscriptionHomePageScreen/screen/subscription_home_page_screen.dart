import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionHomePageScreen extends StatefulWidget {
  const SubscriptionHomePageScreen({super.key});

  @override
  State<SubscriptionHomePageScreen> createState() =>
      _SubscriptionHomePageScreenState();
}

class _SubscriptionHomePageScreenState
    extends State<SubscriptionHomePageScreen> {
  String getSubscriptionLength() {
    return "15 Day Subscription";
  }

  DateTime getLastDeliveryDate() {
    return DateTime.now();
  }

  int getRemainingDaysQuantity() {
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    // This only returns the body which is used in the scaffold of the HomeScreen()
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
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
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
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
                        getSubscriptionLength(),
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
                        ' Last Delivered on ${DateFormat('d MMM yy').format(getLastDeliveryDate())}',
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
                        onTap: () {},
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 13),
                    child: Text(
                      '${getRemainingDaysQuantity()} Days remaining',
                      style: const TextStyle(
                        color: Color(0xFFF84545),
                        fontSize: 11,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 16 / 11,
                        letterSpacing: 0.50,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
