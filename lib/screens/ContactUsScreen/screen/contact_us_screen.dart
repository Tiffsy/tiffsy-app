import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo/logo2.svg',
              semanticsLabel: 'vector image',
              height: 250,
              width: 250,
            ),
            SizedBox(height: 100),
            customVerticalCardButton(
                text: "+91 9530077899, +91 7906773343",
                icon: Icons.phone,
                onPressed: () {}),
            SizedBox(
              height: 20,
            ),
            customVerticalCardButton(
                text: "Support@tiffsy.com", icon: Icons.mail, onPressed: () {}),
            SizedBox(height: 30,),
            const Text("• Love to hear feedback!, contact us anytime",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),),
            SizedBox(height: 10,),
            Image(
              image: AssetImage('assets/images/logo/makeInIndia.jpeg'), // Replace with your actual image path
              height: 80,
              width: 100,
          ),
          ],
        ),
      ),
    );
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
}
