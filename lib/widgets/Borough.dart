import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoroughWidget extends StatefulWidget {
  final TextEditingController boroughController;

  const BoroughWidget({super.key, required this.boroughController});

  @override
  State<BoroughWidget> createState() => _BoroughWidgetState();
}

class _BoroughWidgetState extends State<BoroughWidget> {
  final List<int> options = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: widget.boroughController.text.isEmpty
                ? null
                : widget.boroughController.text,
            decoration: InputDecoration(
              hintText: 'Borough',
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
                widget.boroughController.text = newValue!;
              });
            },
            items: options.map((int value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
