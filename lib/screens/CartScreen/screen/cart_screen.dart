import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffsy_app/screens/CartScreen/bloc/cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: Scaffold(
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(),
                  ElevatedButton(
                      onPressed: (

                      ) {}, child: Text("Order For ToDay")),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Order For Week")),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Order For 15 Days")),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Order For Month")),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
