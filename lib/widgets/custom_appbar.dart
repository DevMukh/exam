import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/themes.dart';

class CustomAppbar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String id;

  const CustomAppbar({
    super.key,
    required this.scaffoldKey,
    required this.id,
  });

  Stream<Map<String, dynamic>?> streamUserProfile() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value(null); // Return an empty stream if user is not authenticated

    return FirebaseFirestore.instance
        .collection('exam')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists ? snapshot.data() as Map<String, dynamic>? : null);
  }

  @override
  Widget build(BuildContext context) {
    TextStyling textStyling = TextStyling();

    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.32),
      child: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xffF8F9FD),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/Frame2.png',
                        height: 36,
                        width: 136,
                      ),
                      IconButton(
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 34,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  StreamBuilder<Map<String, dynamic>?>(
                    stream: streamUserProfile(),
                    builder: (context, snapshot) {
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userData['phoneNumber'] ?? 'Phone Number',
                                  style: textStyling.customAppBarStyle,
                                ),
                                Text(
                                  userData['fullName'] ?? 'Full Name',
                                  style: textStyling.customAppBarStyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userData['whatsappNumber'] ?? 'WhatsApp Number',
                                  style: textStyling.customAppBarStyle,
                                ),
                                Text(
                                  userData['occupation'] ?? 'Occupation',
                                  style: textStyling.customAppBarStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Govt. High School',
                              style: textStyling.customAppBarHeading,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
