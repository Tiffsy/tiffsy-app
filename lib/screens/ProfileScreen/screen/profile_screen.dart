import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Profile();
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var _mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 5, bottom: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: theme.cardColor,
                elevation: 0,
                margin: EdgeInsets.only(top: 5, bottom: 5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: _mediaQuery.size.width,
                  height: 112,
                  child: Row(children: [
                    SizedBox(width: 24,),
                    IconButton(
                        onPressed: () => {},
                        icon: ClipOval(
                          child: (user.photoURL != null)
                      ? Image.network('${user.photoURL}', fit: BoxFit.cover, height: 64, width: 64,)
                      : Container(
                        height: 64,
                        width: 64,
                        child: Center(child: Text("R")),
                        color: Colors.teal[100],
                      ))
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tiffsy',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter'),
                        ),
                      ],
                    )
                  ]),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customButton(
                      text: 'Subscription',
                      icon: Icon(
                        Icons.food_bank,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPress: () => {
                        
                      }),
                  customButton(
                      text: 'Payments',
                      icon: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPress: () => {}),
                  customButton(
                      text: 'Settings',
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPress: () => {})
                ],
              ),
              SizedBox(height: 10),
              customCardButton(
                  context: context,
                  text: 'Order History',
                  icon: const Icon(
                    Icons.history,
                    color: Color(0xffF3A204),
                    size: 24,
                  ),
                  onPressed: () => {}),
              customCardButton(
                  context: context,
                  text: 'Address Book',
                  icon: const Icon(
                    Icons.home,
                    color: Color(0xffF3A204),
                    size: 24,
                  ),
                  onPressed: () => {}),
              customCardButton(
                  context: context,
                  text: 'Contact Us',
                  icon: const Icon(
                    Icons.phone_enabled,
                    color: Color(0xffF3A204),
                    size: 24,
                  ),
                  onPressed: () => {}),
              customCardButton(
                  context: context,
                  text: 'About Us',
                  icon: const Icon(
                    Icons.people,
                    color: Color(0xffF3A204),
                    size: 24,
                  ),
                  onPressed: () => {}),
              customCardButton(
                  context: context,
                  text: 'Feedback',
                  icon: const Icon(
                    Icons.forum,
                    color: Color(0xffF3A204),
                    size: 24,
                  ),
                  onPressed: () => {}),
              logoutButton(
                  context: context,
                  text: 'Logout',
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  onPressed: () => {})
            ]),
      ),
    );
  }
}

Widget customCardButton(
    {required BuildContext context,
    required String text,
    required Icon icon,
    required VoidCallback onPressed}) {
  final ThemeData theme = Theme.of(context);
  var _mediaQuery = MediaQuery.of(context);
  return SizedBox(
    width: _mediaQuery.size.width,
    height: 48,
    child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: theme.cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed,
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    ),
  );
}

Widget logoutButton(
    {required BuildContext context,
    required String text,
    required Icon icon,
    required VoidCallback onPressed}) {
  final ThemeData theme = Theme.of(context);
  var _mediaQuery = MediaQuery.of(context);
  return SizedBox(
    width: _mediaQuery.size.width,
    height: 48,
    child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.white),
            )
          ],
        ),
      ),
    ),
  );
}

Widget customButton(
    {required String text, required Icon icon, required VoidCallback onPress}) {
  return SizedBox(
    width: 113,
    height: 80,
    child: Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            maximumSize: Size(113, 80),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon, // Replace with your desired icon
            const SizedBox(width: 8.0), // Add space between icon and text
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );
}
