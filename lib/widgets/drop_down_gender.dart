import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatefulWidget {
  final TextEditingController genderController;

  const DropDownButtonWidget({super.key, required this.genderController});

  @override
  State<DropDownButtonWidget> createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {
  final List<String> options = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: widget.genderController.text.isEmpty ? null : widget.genderController.text,
            decoration: InputDecoration(
              hintText: 'Gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FD),
            ),
            onChanged: (String? newValue) {
              setState(() {
                widget.genderController.text = newValue!;
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
