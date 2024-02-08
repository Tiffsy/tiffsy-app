import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffsy_app/Helpers/loading_animation.dart';
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
      body: SingleChildScrollView(
        child: BlocProvider(
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
                return Center(
                  child: LoadingAnimation.loadingAnimationTwo(context),
                );
              } else if (state is PersonalDetailsInitial) {
                if (state.isPhoneAuth) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          entryBox(name, "Name", AutofillHints.name),
                          const SizedBox(height: 24),
                          entryBox(email, "Email ID", AutofillHints.email),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () async {
                              if (name.text.isNotEmpty &&
                                  email.text.contains("@")) {
                                    final FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                    CollectionReference users = firestore.collection('email');
                                    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();
                                    
                                    if(querySnapshot.docs.isNotEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Email is already registered!")));
                                    }
                                    else{
                                       BlocProvider.of<PersonalDetailsBloc>(context)
                                        .add(
                                      ContinueButtonClickedForEmailEvent(
                                          name: name.text,
                                          number: widget.phoneNumber,
                                          mailId: email.text),
                                    );
                                    }
                              } else {
                                
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
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80),
                          const Text(
                            "Let us know how to address you",
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 20 / 14,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(height: 40),
                          entryBox(name, "Name", AutofillHints.name),
                          const SizedBox(height: 24),
                          entryBox(number, "10-digit Phone Number",
                              AutofillHints.telephoneNumber),
                          const SizedBox(height: 40),
                          continueButton(
                            () async {
                              if (name.text.isNotEmpty &&
                                  number.text.length == 10) {
                                final FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                CollectionReference users =
                                    firestore.collection('users_phone');
                                QuerySnapshot querySnapshot = await users
                                    .where('phoneNumber',
                                        isEqualTo: number.text)
                                    .get();
                                if (querySnapshot.docs.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Phone Number is already registered!")));
                                } else {
                                  BlocProvider.of<PersonalDetailsBloc>(context).add(
                                    ContinueButtonClickedForEmailEvent(
                                        name: name.text,
                                        number: number.text,
                                        mailId: user.email!),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Invalid data entered")));
                              }
                            },
                          ),
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

Widget continueButton(VoidCallback onpress) {
  Widget buttonText = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      Text(
        "Continue",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xff121212),
          height: 24 / 16,
        ),
      ),
      Spacer()
    ],
  );
  return InkWell(
    onTap: () {
      onpress();
    },
    child: Container(
      constraints: const BoxConstraints(maxHeight: 40),
      decoration: BoxDecoration(
        color: const Color(0xffffbe1d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 24, 10),
        child: buttonText,
      ),
    ),
  );
}
