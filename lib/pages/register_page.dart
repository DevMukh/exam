import 'package:exam/pages/sign_in_using_phone.dart';
import 'package:exam/pages/verificiation_otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/register_user_model.dart';
import '../services/register_user_handle.dart';
import '../utils/themes.dart';
import '../widgets/Borough.dart';
import '../widgets/check_box.dart';
import '../widgets/countrycode_textfield.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/drop_down_gender.dart';
import '../widgets/elevated_button.dart';
import '../widgets/occupation_dropdown.dart';
import '../widgets/password_textfield.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/state_dropdown.dart';
import '../widgets/year_selection.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AppColors clr = AppColors();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController whatsappNumberController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController boroughController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  String _verificationId = '';

  void _registerUser(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    await _verifyPhoneNumber();
  }

  Future<void> _verifyPhoneNumber() async {
    final phoneNumber = formatPhoneNumber(phoneNumberController.text);

    print('Formatted phone number: $phoneNumber'); // Debug print

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _saveUserProfile();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),

        );
        print(' this is error message still facing:::::${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationPage(
              verificationId: _verificationId,
              onVerify: _saveUserProfile,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters and ensure it's in E.164 format
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return '+$cleanedNumber';
  }

  Future<void> _saveUserProfile() async {
    final userProfile = UserProfile(
      fullName: nameController.text,
      gender: genderController.text,
      occupation: occupationController.text,
      phoneNumber: phoneNumberController.text,
      whatsappNumber: whatsappNumberController.text,
      email: emailController.text,
      state: stateController.text,
      borough: boroughController.text,
      year: yearController.text,
      password: passwordController.text,
      bankAccount: bankAccountController.text,
      uid:FirebaseAuth.instance.currentUser?.uid ?? ''
    );

    await saveUserProfile(userProfile);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SignInUsingPhone()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/signIn.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Text(
                  "Create Account",
                  style: TextStyle(
                      color: clr.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: "Full Name",
                  keyboardType: TextInputType.text,
                  controller: nameController,
                ),
                const SizedBox(height: 10),
                DropDownButtonWidget(genderController: genderController),
                const SizedBox(height: 10),
                OccupationDropdown(occupationController: occupationController),
                const SizedBox(height: 10),
                CountryCodeTextField(
                  title: 'Phone Number',
                  onCodePicked: (val) => phoneNumberController.text = val,
                  initialCode: '+249', // Use initialCode instead of code
                  phoneController: phoneNumberController,
                ),
                const SizedBox(height: 10),
                CountryCodeTextField(
                  title: 'WhatsApp Number',
                  onCodePicked: (val) => whatsappNumberController.text = val,
                  initialCode: '+',
                  phoneController: whatsappNumberController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                StateDropdown(stateController: stateController),
                const SizedBox(height: 10),
                BoroughWidget(boroughController: boroughController),
                const SizedBox(height: 10),
                const StandardSearchBarWidget(),
                const SizedBox(height: 10),
                YearSelector(yearController: yearController),
                const SizedBox(height: 10),
                PasswordTextField(
                  title: 'Password',
                  showVisibilityIcon: false,
                  password: passwordController,
                ),
                const SizedBox(height: 10),
                PasswordTextField(
                  title: 'Confirm Password',
                  showVisibilityIcon: false,
                  password: confirmPasswordController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Bank Account',
                  keyboardType: TextInputType.number,
                  controller: bankAccountController,
                ),
                const SizedBox(height: 10),
                CheckBoxWidget(
                  onChecked: () => _registerUser(context),
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  title: "Register",
                  onPressed: () => _registerUser(context),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: clr.textColor),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign-in page
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: clr.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
