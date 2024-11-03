import 'package:flutter/material.dart';
import 'country_code_picker.dart';
import 'custom_text_field.dart';

class CountryCodeTextField extends StatefulWidget {
  final String title;
  final String initialCode; // This parameter should be used
  final Function(String) onCodePicked;
  final TextEditingController phoneController;

  CountryCodeTextField({
    Key? key,
    required this.title,
    required this.initialCode,
    required this.phoneController,
    required this.onCodePicked,
  }) : super(key: key);

  @override
  _CountryCodeTextFieldState createState() => _CountryCodeTextFieldState();
}

class _CountryCodeTextFieldState extends State<CountryCodeTextField> {
  late String _selectedCountryCode;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCode;
    widget.phoneController.addListener(_onPhoneNumberChanged);
  }

  void _onPhoneNumberChanged() {
    if (_isUpdating) return;

    final phoneNumber = widget.phoneController.text;
    if (phoneNumber.startsWith(_selectedCountryCode)) return; // No need to update if already formatted

    _isUpdating = true;
    widget.phoneController.text = '$_selectedCountryCode$phoneNumber';
    widget.phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.phoneController.text.length),
    );
    _isUpdating = false;
  }

  @override
  void dispose() {
    widget.phoneController.removeListener(_onPhoneNumberChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CountryCodePickerWidget(
          initialCountryCode: _selectedCountryCode,
          onCodePicker: (countryCode) {
            setState(() {
              _selectedCountryCode = countryCode;
              widget.onCodePicked(countryCode);
            });
            _onPhoneNumberChanged(); // Update phone number after code change
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            hintText: widget.title,
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
