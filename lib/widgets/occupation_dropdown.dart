import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OccupationDropdown extends StatefulWidget {
  final TextEditingController occupationController;

  OccupationDropdown({super.key, required this.occupationController});

  @override
  State<OccupationDropdown> createState() => _OccupationDropdownState();
}

class _OccupationDropdownState extends State<OccupationDropdown> {
  final List<String> options = [
    'Teacher',
    'Sub Teacher',
    'Principal',
    'Administrator',
    'Accounting'
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: widget.occupationController.text.isEmpty
                ? null
                : widget.occupationController.text,
            decoration: InputDecoration(
              hintText: 'Occupation',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FD),
            ),
            onChanged: (String? newValue) {
              setState(() {
                widget.occupationController.text = newValue!;
              });
            },
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
