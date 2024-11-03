import 'package:exam/pages/chating_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/chat_user_available.dart';

class FloatingChatingButton extends StatelessWidget {
  const FloatingChatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>  ChatUserAvailable()));
      },
      child: const Text("chat"),
    );
  }
}
