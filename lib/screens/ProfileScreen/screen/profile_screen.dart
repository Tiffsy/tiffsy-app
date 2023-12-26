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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Map getHorizontalListButtonOptions() {
    return {
      "Subscription": [
        Icons.food_bank,
        () {
          print("Subscription");
        }
      ],
      "Payments": [
        Icons.credit_card,
        () {
          print("Payments");
        }
      ],
      "Settings": [
        Icons.settings,
        () {
          print("Settings");
        }
      ],
    };
  }

  Map getVerticalListButtonOptions() {
    return {
      "Order History": [
        Icons.history,
        () {
          print("Order History");
        }
      ],
      "Address Book": [Icons.home, () {}],
      "Contact Us": [Icons.phone_enabled, () {}],
      "About Us": [Icons.people, () {}],
      "Feedback": [Icons.forum, () {}],
    };
  }

  void logoutOnPress() {}

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    print(MediaQuery.sizeOf(context).width);
    return Scaffold(
      backgroundColor: const Color(0xfffffcef),
      appBar: AppBar(
        backgroundColor: const Color(0xfffffcef),
        leadingWidth: 64,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xff323232),
            size: 24,
          ),
          onPressed: () {
            // go back functionality, most likely using Navigator.pop()
          },
        ),
        title: const Text(
          "Your Profile",
          style: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff121212),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  userCard(user),
                  const SizedBox(height: 12),
                  listOfHorizontalCardButtons(getHorizontalListButtonOptions(),
                      MediaQuery.sizeOf(context).width),
                  const SizedBox(height: 12)
                ] +
                listOfVerticalOptions(
                    getVerticalListButtonOptions(), logoutOnPress),
          ),
        ),
      ),
    );
  }
}

Widget userCard(User user) {
  return Builder(builder: (context) {
    String name = user.displayName ?? "User";
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      height: 112,
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          IconButton(
            onPressed: () => {},
            icon: ClipOval(
              child: (user.photoURL == null)
                  ? Image.network(
                      '${user.photoURL}',
                      fit: BoxFit.cover,
                      height: 64,
                      width: 64,
                    )
                  : Container(
                      height: 64,
                      width: 64,
                      color: Colors.teal[100],
                      child: Center(
                        child: Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 18),
          Text(
            user.displayName ?? "User",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF121212),
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 0.07,
            ),
          )
        ],
      ),
    );
  });
}

Widget listOfHorizontalCardButtons(Map options, double width) {
  List<Widget> listOfOptionCards = [];
  options.forEach((key, value) {
    listOfOptionCards.addAll([
      const SizedBox(width: 12),
      customHorizontalCardButton(
          text: key, icon: value[0], onPressed: value[1], width: width),
    ]);
  });
  listOfOptionCards.removeAt(0);
  if (width < 342) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: listOfOptionCards,
      ),
    );
  } else {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: listOfOptionCards,
    );
  }
}

Widget customHorizontalCardButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
  required double width,
}) {
  width = (width - 48 - 24) / 3;
  double minWidth = 90;
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xffffffff)),
    width: (width > minWidth) ? width : minWidth,
    height: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Icon(
          icon,
          size: 34,
          color: const Color(0xffffbe1d),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff121212),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}

List<Widget> listOfVerticalOptions(Map options, VoidCallback logoutOnPress) {
  List<Widget> listOfOptionCards = [];
  options.forEach((key, value) {
    listOfOptionCards.addAll([
      customVerticalCardButton(text: key, icon: value[0], onPressed: value[1]),
      const SizedBox(height: 12)
    ]);
  });
  listOfOptionCards.add(logoutButton(
      text: "Logout",
      icon: Icons.power_settings_new,
      onPressed: logoutOnPress));
  return listOfOptionCards;
}

Widget customVerticalCardButton(
    {required String text,
    required IconData icon,
    required VoidCallback onPressed}) {
  return Builder(builder: (context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        height: 48,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, color: const Color(0xffffbe1d), size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xff121212),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                letterSpacing: 0.5,
              ),
            )
          ],
        ),
      ),
    );
  });
}

Widget logoutButton(
    {required String text,
    required IconData icon,
    required VoidCallback onPressed}) {
  return Builder(builder: (context) {
    var width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: width,
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
              Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                  letterSpacing: 0.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  });
}
