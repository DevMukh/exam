import 'package:exam/pages/sign_in_using_phone.dart';
import 'package:exam/widgets/app_bar_widget.dart';
import 'package:exam/widgets/elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/themes.dart';

class EmailVerifyPage extends StatelessWidget {
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController conformPassword = TextEditingController();
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  EmailVerifyPage({super.key});
  AppColors clr = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.backgroundColors,
      appBar: AppBarWidget(
        title: "Check Your Email",
        leadingIcon: const Icon(null),
        backgroundColor: clr.backgroundColors,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'We have sent a password recovery instructions to your phone number.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ButtonWidget(
                title: 'Okay',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignInUsingPhone()));
                }),
            const SizedBox(
              height: 10,
            ),
            const Text('Did you not receive an email?'),
            InkWell(
                onTap: () {
                  /*
                  there to apply on tap in try again email link verification
                   */
                },
                child: Text(
                  'Try Again',
                  style: TextStyle(
                      color: clr.textColor, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
