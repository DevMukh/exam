import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>> fetchExamData(String documentId) async {
  if (documentId.isEmpty) {
    throw ArgumentError('Document ID cannot be empty');
  }

  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('exam')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print("this is the doc if::::::::::::::::::::$documentId");
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  } catch (e) {
    throw Exception('Error fetching document: $e');
  }
}
