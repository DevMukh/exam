import 'package:exam/pages/chating_page.dart';
import 'package:exam/pages/home_page.dart';
import 'package:exam/services/chat/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/chat/chat_services.dart';
import '../widgets/user_tile.dart';

class ChatUserAvailable extends StatelessWidget {
  ChatUserAvailable({super.key});
//chat auth
  final ChatService _chatService = ChatService();
  final AuthServices _services = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Users"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: _buildUserList(),
    );
  }

  //build list of user except login wala
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error ${snapshot.hasError}");
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Error ${snapshot.hasError}");
            return const Center(child: CircularProgressIndicator());
          }
          //return list view of user
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // Get the current user's UID
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    // Print statements for debugging
    print("This is the current user uid: $currentUserUid");
    print("This is the user id from userData: ${userData['user_id']}");

    // Check if the user's UID matches the logged-in user's UID
    if (userData['user_id'] != currentUserUid) {
      return UserTile(
        text: userData['occupation'],
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChatingPage(
                receiverEmail: userData['email'],
                receiverId: userData['user_id'],
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Exclude the current user
    }
  }
}
