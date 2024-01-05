import 'package:flutter/material.dart';

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
            ElevatedButton(onPressed: () {}, child: Text("Order For ToDay")),
            ElevatedButton(onPressed: () {}, child: Text("Order For Week")),
            ElevatedButton(onPressed: () {}, child: Text("Order For 15 Days")),
            ElevatedButton(onPressed: () {}, child: Text("Order For Month")),
          ],
        ),
      ),
    );
  }
}