// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   Future<List<Map<String, dynamic>>> getUserRewards() async {
//
//     try {
//       QuerySnapshot querySnapshot = (await _db
//           .collection('rewardList')
//
//           .get()) as QuerySnapshot<Object?>;
//
//       List<Map<String, dynamic>> rewards = [];
//       for (var doc in querySnapshot.docs) {
//         rewards.add(doc.data() as Map<String, dynamic>);
//       }
//       return rewards;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Failed to fetch user rewards: $e');
//       }
//       return [];
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserDocumentIfNotExists() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('rewardList').doc(user.uid);

    // Check if the document exists
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      // Initialize the document with default values
      await docRef.set({
        'first': [
          {
            'student': 0,
            'bonus': 0,
            'totalEarning': 0,
          }
        ],
      });
    }
  }

  Future<List<Map<String, dynamic>>> getUserRewards() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final docRef = _db.collection('rewardList').doc(user.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return [];
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final first = data['first'] as List<dynamic>? ?? [];
      return [data]; // Return the document data wrapped in a list
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch user rewards: $e');
      }
      return [];
    }
  }
}
