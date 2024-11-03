import 'package:exam/pages/password_change.dart';
import 'package:exam/utils/themes.dart';
import 'package:exam/widgets/app_bar_widget.dart';
import 'package:exam/widgets/elevated_button.dart';
import 'package:exam/widgets/countrycode_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController newPassword=TextEditingController();
  final TextEditingController conformPassword=TextEditingController();
  final TextEditingController oldPassword=TextEditingController();
  final TextEditingController countryCodePicker=TextEditingController();
  AppColors clr = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.backgroundColors,
      appBar: const AppBarWidget(
        title: 'Reset Password',
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body:  Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Enter the phone number associated with your account and we’ll send instructions to reset your password.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  CountryCodeTextField(
                    title: 'Phone Number',
                    initialCode: '+249', phoneController:phoneController, onCodePicked: (val){
                     countryCodePicker;
                  },
                  ),
                  const SizedBox(height: 30), // Add some space before the button
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonWidget(
                title: 'Send Instructions',
                onPressed: () {
                  // Your button action here
                  // EmailVerifyPage
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>EmailVerifyPage()));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PasswordChangePage()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
