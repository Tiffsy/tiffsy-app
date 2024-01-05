import 'package:flutter/material.dart';
import 'package:tiffsy_app/Helpers/page_router.dart';
import 'package:tiffsy_app/screens/SubscriptionScreen/screen/subscription_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideTransitionRouter.toNextPage(
                          SubscriptionScreen(noOfDays: 1)));
                },
                child: Text("Order For ToDay")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideTransitionRouter.toNextPage(
                          SubscriptionScreen(noOfDays: 7)));
                },
                child: Text("Order For Week")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideTransitionRouter.toNextPage(
                          SubscriptionScreen(noOfDays: 15)));
                },
                child: Text("Order For 15 Days")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideTransitionRouter.toNextPage(
                          SubscriptionScreen(noOfDays: 30)));
                },
                child: Text("Order For Month")),
          ],
        ),
      ),
    );
  }
}
