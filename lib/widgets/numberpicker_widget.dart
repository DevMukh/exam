import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/reward_list.dart';
import '../utils/themes.dart';

class NumberPickerFlutterWidget extends StatefulWidget {
  final int totalEarning;

  const NumberPickerFlutterWidget({super.key, required this.totalEarning});

  @override
  __IntegerExampleState createState() => __IntegerExampleState();
}

class __IntegerExampleState extends State<NumberPickerFlutterWidget> {
  late int _totalEarning;

  TextStyling textStyling = TextStyling();

  @override
  void initState() {
    super.initState();
    _totalEarning = widget.totalEarning; // Initialize with received value
    print("this is number picker total earning $_totalEarning");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const RewardList()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_forward_ios_sharp,
            color: Colors.green,
          ),
          NumberPicker(
            value: _totalEarning,
            minValue: 0,
            maxValue: 1000000,
            step: 1,
            itemHeight: 30,
            selectedTextStyle: textStyling.valueRangePicker,
            onChanged: (value) {
              setState(() {
                _totalEarning = value;
                print('NumberPicker value changed: $_totalEarning');
              });
            },
          ),
          const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
