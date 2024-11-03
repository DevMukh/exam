import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryCodePickerWidget extends StatefulWidget {
  final String initialCountryCode;
  final Function(String) onCodePicker;

  CountryCodePickerWidget({
    Key? key,
    required this.onCodePicker,
    this.initialCountryCode = '+93', // Default to Afghanistan's country code
  }) : super(key: key);

  @override
  State<CountryCodePickerWidget> createState() =>
      _CountryCodePickerWidgetState();
}

class _CountryCodePickerWidgetState extends State<CountryCodePickerWidget> {
  late String countryCode;

  @override
  void initState() {
    super.initState();
    countryCode = widget.initialCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          countryListTheme: const CountryListThemeData(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
            ),
            inputDecoration: InputDecoration(
              hintText: 'Start typing to search',
              labelText: 'Search',
            ),
          ),
          onSelect: (Country value) {
            setState(() {
              countryCode = '+${value.phoneCode}';
            });
            widget.onCodePicker(countryCode);
          },
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        backgroundColor: const Color(0xFFF8F9FD),
        side: const BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Center(
        child: Text(
          countryCode,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
