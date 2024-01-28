import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffsy_app/screens/HomeScreen/screen/home_screen.dart';
import 'package:tiffsy_app/screens/PersonalDetailsScreen/bloc/personal_details_bloc.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen(
      {Key? key, required this.isPhoneAuth, required this.phoneNumber})
      : super(key: key);
  final bool isPhoneAuth;
  final String phoneNumber;
  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    PersonalDetailsBloc personalDetailsBloc = PersonalDetailsBloc(
        PersonalDetailsInitial(isPhoneAuth: widget.isPhoneAuth));
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Personal Details"),
        ),
      ),
      body: BlocProvider(
        create: (context) => personalDetailsBloc,
        child: BlocConsumer<PersonalDetailsBloc, PersonalDetailsState>(
          listener: (context, state) {
            if (state is ScreenErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is ContinueButtonClickedSuccessState) {
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
            } else if (state is PersonalDetailsInitial) {
              if (state.isPhoneAuth) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        entryBox(name, "Name", AutofillHints.name),
                        const SizedBox(height: 20),
                        entryBox(email, "Email ID", AutofillHints.email),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (name.text.isNotEmpty &&
                                email.text.contains("@")) {
                              BlocProvider.of<PersonalDetailsBloc>(context).add(
                                ContinueButtonClickedForEmailEvent(
                                    name: name.text,
                                    number: widget.phoneNumber,
                                    mailId: email.text),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid data entered")));
                            }
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Color(0xff121212)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        entryBox(name, "Name", AutofillHints.name),
                        const SizedBox(height: 20),
                        entryBox(number, "10-digit Phone Number",
                            AutofillHints.telephoneNumber),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (name.text.isNotEmpty &&
                                number.text.length == 10) {
                              BlocProvider.of<PersonalDetailsBloc>(context).add(
                                ContinueButtonClickedForEmailEvent(
                                    name: name.text,
                                    number: number.text,
                                    mailId: user.email!),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid data entered")));
                            }
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Color(0xff121212)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

Widget entryBox(
    TextEditingController controller, String label, String? autofillHints) {
  Iterable<String>? autoFill = autofillHints == null ? {} : {autofillHints};
  return TextFormField(
    autofillHints: autoFill,
    controller: controller,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 24 / 16,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0x66121212),
        height: 24 / 16,
      ),
    ),
  );
}
