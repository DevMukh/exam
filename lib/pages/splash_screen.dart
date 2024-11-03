import 'package:exam/pages/home_page.dart'; // Import your home page
import 'package:exam/pages/sign_in_using_phone.dart'; // Import your sign-in page
import 'package:exam/pages/register_page.dart'; // Import your registration page
import 'package:exam/utils/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

AppColors clr = AppColors();

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAppropriatePage();
  }

  void _navigateToAppropriatePage() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>HomePage()), // Replace with your home page          HomePage
      );
    } else {
      // User is not logged in, navigate to the sign-in page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInUsingPhone()), // Replace with your registration page
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.backgroundColors,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Frame4.png',
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .300),
                  child: const Text(
                    'coordinator',
                    style: TextStyle(
                      fontFamily: "",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 10.0,
                animation: true,
                percent: 0.7,
                center: const Text(
                  "70.0%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
