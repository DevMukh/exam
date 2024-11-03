import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateDropdown extends StatefulWidget {
  final TextEditingController stateController;

  const StateDropdown({super.key, required this.stateController});

  @override
  State<StateDropdown> createState() => _StateDropdownState();
}

class _StateDropdownState extends State<StateDropdown> {
  List<String> states = [
    'StateA',
    'StateB',
    'StateC',
    'StateD',
    'StateE',
    'StateF'
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Stack(
            children: [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    widget.stateController.text = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return states.map((String value) {
                    return PopupMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList();
                },
                // Adjust the position of the dropdown menu
                offset: const Offset(0, 50),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
                    widget.stateController.text.isEmpty
                        ? 'State'
                        : widget.stateController.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  tileColor: const Color(0xFFF8F9FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
