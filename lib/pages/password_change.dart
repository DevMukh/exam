import 'package:exam/widgets/app_bar_widget.dart';
import 'package:exam/widgets/elevated_button.dart';
import 'package:exam/widgets/password_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/themes.dart';
import 'email_verify_page.dart';

class PasswordChangePage extends StatefulWidget {
  PasswordChangePage({super.key,});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController conformPassword = TextEditingController();
  final TextEditingController oldPassword=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  AppColors clr = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.backgroundColors,
      appBar: AppBarWidget(
        title: "Change Password",
        // leadingIcon: IconButton(icon: Icon(Icons.arrow_back_rounded),onPressed: (){},),
        backgroundColor: clr.backgroundColors,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                PasswordTextField(title: "Old Password", password: oldPassword,),
                const SizedBox(
                  height: 20,
                ),
                PasswordTextField(title: "New Password",password:newPassword ,),
                const SizedBox(height: 20),
                PasswordTextField(
                  title: "Confirm Password",
                  password:conformPassword,
                  showVisibilityIcon: false,
                )
              ],
            )),
            ButtonWidget(
                title: 'Change Password',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EmailVerifyPage()));
                })
          ],
        ),
      ),
    );
  }
}
