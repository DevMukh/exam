import 'package:exam/pages/password_reset.dart';
import 'package:exam/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/themes.dart';
import '../widgets/country_code_picker.dart';
import '../widgets/elevated_button.dart';
import 'home_page.dart';
import 'login_otp_verficiation_page.dart';

class SignInUsingPhone extends StatefulWidget {
  SignInUsingPhone({super.key});

  @override
  State<SignInUsingPhone> createState() => _SignInUsingPhoneState();
}

class _SignInUsingPhoneState extends State<SignInUsingPhone> {
  AppColors clr = AppColors();
  final TextEditingController phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String countryCode = '+92'; // Default country code

  void _signInUser() async {
    if (_validatePhoneNumber()) {
      await _verifyPhoneNumber();
    }
  }

  bool _validatePhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();
    print("Phone number entered for login: $phoneNumber");

    // Add '+' sign if missing
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = countryCode + phoneNumber;
      phoneNumberController.text = phoneNumber;
    }

    // Check if phone number starts with '+' and is followed by digits only
    if (phoneNumber.isEmpty ||
        !RegExp(r'^\+\d{10,15}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return false;
    }
    return true;
  }

  Future<void> _verifyPhoneNumber() async {
    final phoneNumber = phoneNumberController.text.trim();
    print("Verifying phone number: $phoneNumber");

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationPage(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.backgroundColors,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/signIn.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: clr.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CountryCodePickerWidget(
                          initialCountryCode: countryCode,
                          onCodePicker: (val) {
                            setState(() {
                              countryCode = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 6,
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
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
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  InkWell(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>PasswordReset()));},
                      child:const Text('Forget Password',style: TextStyle(color: Colors.grey),))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ButtonWidget(
                  title: "Send OTP",
                  onPressed: _signInUser,
                ),
                const SizedBox(height: 20,),
                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don’t have an account?'),
                    InkWell(
                        onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>RegisterPage()));},
                        child: Text('Sign Up',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
