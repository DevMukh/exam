import 'dart:async'; // Import the async library for Timer

import 'package:exam/pages/sign_in_using_phone.dart'; // Update the import path
import 'package:exam/widgets/app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/themes.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final VoidCallback onVerify;

  OtpVerificationPage({
    required this.verificationId,
    required this.onVerify,
    super.key,
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

AppColors clr = AppColors();
TextStyling txtStyle = TextStyling();

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isTimeUp = false;
  Timer? _timer;
  int _start = 100; // 1 minute and 40 seconds = 100 seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isTimeUp = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get _formattedTime {
    int minutes = (_start / 60).floor();
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Delay of 2 seconds before navigating
      await Future.delayed(const Duration(seconds: 2));

      // Proceed with any additional operations here, if needed
      widget.onVerify(); // Optional callback if needed

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInUsingPhone()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP or verification failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.backgroundColors,
      appBar: const AppBarWidget(
        title: 'OTP Verification',
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your phone number',
              style: txtStyle.gradesTextColors,
            ),
            const SizedBox(height: 20),
            Text(
              'Time remaining: $_formattedTime',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'OTP',
              ),
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _isTimeUp ? null : _verifyOtp,
                  child: const Text('Verify OTP'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
