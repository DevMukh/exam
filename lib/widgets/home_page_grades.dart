import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/grades_model.dart';
import '../utils/themes.dart';

class HomePageGrades extends StatefulWidget {
  const HomePageGrades({super.key});

  @override
  _HomePageGradesState createState() => _HomePageGradesState();
}

class _HomePageGradesState extends State<HomePageGrades> {
  GradeModel? gradeModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeGrades();
  }

  Future<void> _initializeGrades() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }

    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('examGrades')
          .doc(user.uid);

      // Check if the document exists
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        // Create the document with initial values
        await docRef.set({
          'grade1': 0.0,
          'grade2': 0.0,
          'grade3': 0.0,
        });
      }

      // Fetch the grades
      _fetchGrades();
    } catch (e) {
      print('Failed to initialize grades: $e');
    }
  }

  Future<void> _fetchGrades() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }


    try {
      FirebaseFirestore.instance
          .collection('examGrades')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {

          final data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            gradeModel = GradeModel(
              grade1: (data['grade1'] ?? 0.0).toDouble(),
              grade2: (data['grade2'] ?? 0.0).toDouble(),
              grade3: (data['grade3'] ?? 0.0).toDouble(),

            );
            isLoading = false;

          });
        } else {
          print('No grades found.');
        }
      });

    } catch (e) {
      print('Failed to fetch grades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DynamicGradesColumn(
              grade: '3rd Grade',
              gradePercent: gradeModel!.grade3Percent,
            ),
            DynamicGradesColumn(
              grade: '2nd Grade',
              gradePercent: gradeModel!.grade2Percent,
            ),
            DynamicGradesColumn(
              grade: '1st Grade',
              gradePercent: gradeModel!.grade1Percent,
            ),
          ],
        ),
        const SizedBox(height: 20,),
        SingleTotalLoader(
          total: gradeModel!.totalGradeSum,
        ),

      ],
    );

  }
}

class DynamicGradesColumn extends StatelessWidget {
  final String grade;
  final double gradePercent;

  const DynamicGradesColumn({
    super.key,
    required this.grade,
    required this.gradePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          grade,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 9.0,
          animation: true,
          percent: gradePercent,
          center: Text(
            '${(gradePercent * 100).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.black,
          backgroundColor: Colors.grey[200]!,
        ),
      ],
    );

  }
}
class SingleTotalLoader extends StatelessWidget {
  final double total;

  const SingleTotalLoader({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 50.0,
      lineWidth: 8.0,
      animation: true,
      percent: total / 100, // Adjust if necessary
      center: Text(
        total.toStringAsFixed(0), // Display as an integer percentage
        style: const TextStyle(fontSize:20, fontWeight: FontWeight.bold),
      ),
      progressColor: Colors.black,
      backgroundColor: Colors.grey[200]!,
    );
  }
}

// class SingleTotalLoader extends StatelessWidget {
//   final double total;
//
//   const SingleTotalLoader({
//     super.key,
//     required this.total,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CircularPercentIndicator(
//       radius: 50.0,
//       lineWidth: 8.0,
//       animation: true,
//       percent: total,
//       center: Text(
//         '${(total * 100).toStringAsFixed(1)}',
//         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//       ),
//       progressColor: Colors.black,
//       backgroundColor: Colors.grey[200]!,
//     );
//   }
// }
