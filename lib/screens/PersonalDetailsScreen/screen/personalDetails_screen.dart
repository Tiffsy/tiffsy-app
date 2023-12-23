import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/PersonalDetailsScreen/bloc/personal_details_bloc.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

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
                    TextField(
                      decoration: InputDecoration(hintText: "Name"),
                      controller: name,
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "Mail"),
                      controller: email,
                    ),
                    ElevatedButton(onPressed: () {
                      BlocProvider.of<PersonalDetailsBloc>(context).add(ContinueButtonClickedEvent(name: name.text, mailId: email.text));
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
