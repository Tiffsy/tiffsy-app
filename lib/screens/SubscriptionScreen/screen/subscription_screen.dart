import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffsy_app/screens/SubscriptionScreen/bloc/subscription_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key, required this.subType}) : super(key: key);

  final String subType;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionBloc(SubscriptionInitial(subType: widget.subType)),
      child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is SubscriptionInitial){
            if(state.subType == "today"){
              return Scaffold(
                appBar: AppBar(title: Text("One Day")),
                body: Container(),
              );
            }
            else if(state.subType == "week"){
              return Scaffold(
                appBar: AppBar(title: Text("Weekly Subscription")),
                body: Container(),
              );
            }
            else if(state.subType == "fortnight"){
              return Scaffold(
                appBar: AppBar(title: Text("15 Day Subscription")),
                body: Container(),
              );
            }
            else{
              return Scaffold(
                appBar: AppBar(title: Text("Monthly Subscription")),
                body: Container(),
              );
            }
          }
          return Scaffold();
        },
      ),
    );
  }
}
