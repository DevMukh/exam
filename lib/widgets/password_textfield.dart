import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordTextField extends StatefulWidget {
  final String title;
  final bool showVisibilityIcon;
  final TextEditingController password;
  TextInputType keyboardType;
  PasswordTextField(
      {super.key,
      required this.title,
      this.showVisibilityIcon = true,
      this.keyboardType = TextInputType.visiblePassword, required this.password});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.password,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: widget.title,
        //labelText: widget.title,
        fillColor: const Color(0xFFF8F9FD),
        filled: true,
        suffixIcon: widget.showVisibilityIcon
            ? IconButton(
                icon:
                    Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                })
            : null,
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
    );
  }
}
