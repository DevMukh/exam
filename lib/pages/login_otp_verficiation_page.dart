import 'package:exam/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../widgets/elevated_button.dart';
import 'home_page.dart';
import 'sign_in_using_phone.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  OTPVerificationPage(
      {required this.verificationId, required this.phoneNumber});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;
  late int _start;

  @override
  void initState() {
    super.initState();
    _start = 100; // 1 minute and 40 seconds
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          _navigateToLoginScreen();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SignInUsingPhone()));
  }

  Future<void> _signInWithOtp() async {
    final otp = otpTextController.text.trim();
    print("OTP entered: $otp");

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
      print('Invalid OTP: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const AppBarWidget(
        title: "OTP Verification",
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter OTP sent to ${widget.phoneNumber}',
            style: const TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: otpTextController,
              decoration: InputDecoration(
                hintText: 'OTP',
                fillColor: const Color(0xFFF8F9FD),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
              cursorColor: Colors.black,
            ),
          ),

          // ElevatedButton(
          //   onPressed: _signInWithOtp,
          //   child: Text('Verify OTP'),
          // ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ButtonWidget(
              title: 'Verify OTP',
              onPressed: _signInWithOtp,
            ),
          ),
          const SizedBox(height: 20),
          Text('$_start seconds remaining'),
        ],
      ),
    );
  }
}
