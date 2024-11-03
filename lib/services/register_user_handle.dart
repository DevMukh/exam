import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/register_user_model.dart';

Future<void> saveUserProfile(UserProfile userProfile,) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('exam')
          .doc(user.uid)  // Use UID as document ID
          .set(userProfile.toMap());
      await FirebaseFirestore.instance.collection('Users_Chating').doc(user.uid).set({
        'user_id' : user.uid,
        'email':userProfile.email
      });

      print('User profile saved successfully.');
    } else {
      print('No authenticated user found.');
    }
  } catch (e) {
    print('Failed to save user profile: $e');
  }
}
