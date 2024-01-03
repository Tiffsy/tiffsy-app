import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/PersonalDetailsScreen/bloc/personal_details_bloc.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final bool perviousScreen;
  final String phoneNumber;
  const PersonalDetailsScreen({Key? key, required this.perviousScreen, required this.phoneNumber}): super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalDetailsBloc(PersonalDetailsInitial()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal Details"),
        ),
        body: BlocConsumer<PersonalDetailsBloc, PersonalDetailsState>(
          listener: (context, state) {
            if (state is ScreenErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if(state is ContinueButtonClickedSuccessState){
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()));
            }
          },
          builder: (context, state) {
            if (state is ScreenLoadingScreen) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.perviousScreen,
                      child: TextField(
                        decoration: InputDecoration(hintText: "Name"),
                        controller: name,
                      ),
                    ),
                    Visibility(
                      visible: widget.perviousScreen,
                      child: TextField(
                        decoration: InputDecoration(hintText: "Mail"),
                        controller: email,
                      ),
                    ),
                    Visibility(
                      visible: !widget.perviousScreen,
                      child: TextField(
                        decoration: InputDecoration(hintText: "Phone"),
                        controller: phoneNo,
                      ),
                    ),
                    ElevatedButton(onPressed: () {
                      BlocProvider.of<PersonalDetailsBloc>(context).add(ContinueButtonClickedEvent(name: widget.perviousScreen? name.text : user.displayName! , mailId: widget.perviousScreen? email.text : user.email!, phoneNumber: widget.perviousScreen ? widget.phoneNumber: phoneNo.text));

                    }, child: Text("Continue"))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
