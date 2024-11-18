import 'package:cloud_firestore/cloud_firestore.dart';
//here we fetch the grades from firebase
Future<void> addUserGrades(String phoneNumber, Map<String, dynamic> grades) async {
  try {
    CollectionReference gradesCollection = FirebaseFirestore.instance.collection('examGrades').doc().snapshots() as CollectionReference<Object?>;
        // .collection('exam')
        // .doc('Profile')
        // .collection('RegisterUser')
        // .doc(phoneNumber)
        // .collection('grades');

    // Example of adding a new grade document
    await gradesCollection.add(grades);

    print('Grades added successfully.');
  } catch (e) {
    print('Failed to add grades: $e');
  }
}
