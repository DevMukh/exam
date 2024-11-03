import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class YearSelector extends StatefulWidget {
  final TextEditingController yearController;

  const YearSelector({super.key, required this.yearController});

  @override
  _YearSelectorState createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.yearController,
      decoration: InputDecoration(
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
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  widget.yearController.text = "1st Year";
                });
                if (kDebugMode) {
                  print("1st Year");
                }
              },
              child: const Text(
                "1st Year",
                style: TextStyle(color: Color(0xFFBABABA)),
              ),
            ),
            SizedBox(width: 8), // Add space between texts
            InkWell(
              onTap: () {
                setState(() {
                  widget.yearController.text = "2nd Year";
                });
                if (kDebugMode) {
                  print("2nd Year");
                }
              },
              child: const Text(
                "2nd Year",
                style: TextStyle(color: Color(0xFFBABABA)),
              ),
            ),
            SizedBox(width: 8), // Add space between texts
            InkWell(
              onTap: () {
                setState(() {
                  widget.yearController.text = "3rd Year";
                });
                if (kDebugMode) {
                  print("3rd Year");
                }
              },
              child: const Text(
                "3rd Year",
                style: TextStyle(color: Color(0xFFBABABA)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
