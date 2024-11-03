import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StepProgressIndicatorWidget extends StatelessWidget {
  final int value;
  const StepProgressIndicatorWidget({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: 5,
      currentStep: value ,
      size: 16,
      unselectedColor: Colors.grey.shade400,
      selectedColor: const Color(0xFF94EA7F),
      roundedEdges: const Radius.circular(10),

    );
  }
}
