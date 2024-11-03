import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/pages/sign_in_using_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatefulWidget {
  final String id;
  const DrawerWidget({super.key, required this.id});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late Future<Map<String, dynamic>?> _userProfileFuture;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Initialize the Future with the document ID passed to the widget
      _userProfileFuture = fetchExamData(widget.id);
      print(currentUser.uid);
    } else {
      // Handle the case where the user is null
      print("User is not logged in.");
      // You might want to redirect the user to a login page or show an error message here
    }
  }

  Future<Map<String, dynamic>?> fetchExamData(String documentId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('exam')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (docSnapshot.exists) {
        // Ensure the document exists and contains the data
        print("Document ID: $documentId");
        print("Document Data: ${docSnapshot.data()}");
        return docSnapshot.data() as Map<String, dynamic>?;
      } else {
        // Document does not exist
        print("Document with ID $documentId not found.");
        return null;
      }
    } catch (e) {
      // Handle errors during data fetching
      print("Failed to fetch data: $e");
      return null;
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Navigate to login screen

    } catch (e) {
      print("Failed to log out: $e");
      // Optionally, show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: const Color(0xffF8F9FD),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffF8F9FD),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset(
                  'assets/images/Frame2.png',
                  height: 36,
                  width: 136,
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.2, // 18% of the screen height
              color: const Color(0xFFFFFFFF),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.045), // 4.5% of the screen width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Accounts',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% of the screen height
                    const ElemetWidget(
                      title: 'Update Data',
                      iconData: Icons.refresh,
                      color: Color(0xFFFFB038),
                    ),
                    SizedBox(height: screenHeight * 0.015), // 1.5% of the screen height
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElemetWidget(
                          title: 'Change Password',
                          iconData: Icons.lock,
                          color: Color(0xFF123769),
                        ),
                        Icon(Icons.arrow_forward_ios_sharp),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of the screen height
            Container(
              height: screenHeight * 0.25, // 25% of the screen height
              color: const Color(0xFFFFFFFF),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.045), // 4.5% of the screen width
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _userProfileFuture,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data found.'));
                    } else {
                      final userData = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Contact us',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // 2% of the screen height
                          ElemetWidget(
                            title: userData['email'] ?? 'email',
                            iconData: Icons.email,
                            color: const Color(0xFF1CB0F6),
                          ),
                          SizedBox(height: screenHeight * 0.015), // 1.5% of the screen height
                          ElemetWidget(
                            title: userData['phoneNumber'] ?? 'phoneNumber',
                            iconData: Icons.phone,
                            color: const Color(0xFF58CC02),
                          ),
                          SizedBox(height: screenHeight * 0.015), // 1.5% of the screen height
                          ElemetWidget(
                            title: userData['whatsappNumber'] ?? 'whatsappNumber',
                            iconData: FontAwesomeIcons.whatsapp,
                            color: const Color(0xFF58CC02),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // 1% of the screen height
            Container(
              height: screenHeight * 0.1, // 10% of the screen height
              color: const Color(0xFFFFFFFF),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.045), // 4.5% of the screen width
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const   ElemetWidget(
                          title: 'Delete Account',
                          iconData: Icons.delete_forever_outlined,
                          color: Color(0XFF1CB0F6),
                        ),
                        InkWell(
                            onTap: () async{
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SignInUsingPhone()));
                              print("User deleted");
                            },
                            child: const Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // 1% of the screen height
            Container(
              color: const Color(0xFFFFFFFF),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.045), // 4.5% of the screen width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _logout,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElemetWidget(
                            title: 'Logout',
                            iconData: Icons.logout,
                            color: Color(0XFFEA2B2B),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElemetWidget extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Color color;

  const ElemetWidget({
    super.key,
    required this.title,
    required this.iconData,
    required this.color,

  });

  @override
  State<ElemetWidget> createState() => _ElemetWidgetState();
}

class _ElemetWidgetState extends State<ElemetWidget> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
      fit: FlexFit.tight,
      child: Row(
        children: [
          Icon(
            widget.iconData,
            color: widget.color,
          ),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Container(
            height: screenHeight * 0.03, // 3% of the screen height for the line height
            width: 0.9, // fixed width for the line
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF), // White
                  Color(0xFF000000), // Black
                  Color(0xFFFFFFFF), // Grey
                ],
                stops: [0.0, 0.3, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
