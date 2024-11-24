// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exam/pages/verificiation_otp_page.dart';
// import 'package:exam/pages/wallet_history.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../models/grades_model.dart';
// import '../utils/themes.dart';
// import '../widgets/custom_appbar.dart';
// import '../widgets/drawer_widget.dart';
// import '../widgets/elevated_button.dart';
// import '../widgets/floating_chating_button.dart';
// import '../widgets/home_page_grades.dart';
// import '../widgets/numberpicker_widget.dart';
// import '../widgets/step_progress.dart';
//chat
// class HomePage extends StatefulWidget {
//   HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   List<String> ids = [];
//   List<String> bonus = [];
//   List<String> totalEarning = [];
//   GradeModel? gradeModel;
//   int _totalEarning = 0; // Field to hold the totalEarning value
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchGrades();
//     _fetchTotalEarning(); // Fetch total earning on init
//   }
//
//   Future<void> _fetchGrades() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('No user logged in');
//       return;
//     }
//
//     try {
//       FirebaseFirestore.instance
//           .collection('examGrades')
//           .doc(user.uid)
//           .snapshots()
//           .listen((snapshot) {
//         if (snapshot.exists) {
//           final data = snapshot.data() as Map<String, dynamic>;
//           setState(() {
//             gradeModel = GradeModel(
//               grade1: (data['grade1'] ?? 0.0).toDouble(),
//               grade2: (data['grade2'] ?? 0.0).toDouble(),
//               grade3: (data['grade3'] ?? 0.0).toDouble(),
//             );
//           });
//         } else {
//           print('No grades found.');
//         }
//       });
//     } catch (e) {
//       print('Failed to fetch grades: $e');
//     }
//   }
//
//   Future<void> _fetchTotalEarning() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     try {
//       DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
//           .collection('rewardList')
//           .doc(user.uid)
//           .get();
//
//       if (docSnapshot.exists) {
//         final data = docSnapshot.data() as Map<String, dynamic>;
//         final firstArray = data['first'] as List<dynamic>?;
//
//         if (firstArray != null && firstArray.length > 5) {
//           final totalEarning =
//           (firstArray[5] as Map<String, dynamic>)['totalEarning'];
//           setState(() {
//             _totalEarning = totalEarning ?? 0;
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching totalEarning: $e');
//     }
//   }
//
//   void _navigateToWalletHistory() {
//     print('Navigating to WalletHistory');
//     print('IDs: $ids');
//     print('Bonuses: $bonus');
//     print('Total Earnings: $totalEarning');
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => WalletHistory(
//           // ids: ids,
//           // bonus: bonus,
//           // totalEarning: totalEarning,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User? _user = FirebaseAuth.instance.currentUser;
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//     Stream<DocumentSnapshot> streamRewardList() {
//       if (_user == null) {
//         return Stream.empty();
//       }
//       return _firestore.collection('rewardList').doc(_user.uid).snapshots();
//     }
//
//     TextStyling textStyling = TextStyling();
//
//     return Scaffold(
//       floatingActionButton:const FloatingChatingButton(),
//       key: scaffoldKey,
//       backgroundColor: const Color(0xFFFFFFFF),
//       drawer: const DrawerWidget(id: ''),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomAppbar(
//             scaffoldKey: scaffoldKey,
//             id: _user?.uid ?? '',
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20),
//                     const HomePageGrades(),
//                     const SizedBox(height: 20),
//                     StreamBuilder<DocumentSnapshot>(
//                         stream: streamRewardList(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             print('Error in StreamBuilder: ${snapshot.error}');
//                             return Center(
//                                 child: Text('Error: ${snapshot.error}'));
//                           } else if (snapshot.hasData &&
//                               snapshot.data!.exists) {
//                             final data =
//                             snapshot.data!.data() as Map<String, dynamic>?;
//                             final first =
//                                 data?['first'] as List<dynamic>? ?? [];
//
//                             final bonusArray = first
//                                 .map((e) => e['bonus'] as num? ?? 0)
//                                 .toList();
//                             final studentArray = first
//                                 .map((e) => e['student'] as num? ?? 0)
//                                 .toList();
//                             final totalEarningArray = first
//                                 .map((e) => e['totalEarning'] as num? ?? 0)
//                                 .toList();
//
//                             print('Bonus Array: $bonusArray');
//                             print('Student Array: $studentArray');
//                             print('Total Earning Array: $totalEarningArray');
//
//                             final sixthBonusValue =
//                             bonusArray.length > 5 ? bonusArray[5] : 0;
//                             final nextEntry = studentArray.length > 6
//                                 ? studentArray[6] - studentArray[5]
//                                 : 0;
//
//                             ids = studentArray
//                                 .map((id) => id.toString())
//                                 .toList();
//                             bonus = bonusArray.map((b) => b.toString()).toList();
//                             totalEarning = totalEarningArray.map((e) => e.toString()).toList();
//
//                             if (gradeModel != null) {
//                               double totalGradeSum = (gradeModel!.grade1 +
//                                   gradeModel!.grade2 +
//                                   gradeModel!.grade3) /
//                                   3;
//                               print("Total Grade Sum: $totalGradeSum");
//
//                               num matchedTotalEarning = 0;
//                               num mileBonus = 0;
//                               num entry = 0;
//                               bool foundMatch = false;
//
//                               for (int i = 0; i < studentArray.length; i++) {
//                                 if (studentArray[i] == totalGradeSum) {
//                                   matchedTotalEarning = totalEarningArray[i];
//                                   mileBonus = bonusArray[i];
//                                   entry = studentArray[i];
//                                   foundMatch = true;
//                                   break;
//                                 }
//                               }
//
//                               if (!foundMatch) {
//                                 for (int i = 0; i < studentArray.length; i++) {
//                                   if (studentArray[i] > totalGradeSum) {
//                                     matchedTotalEarning =
//                                     i > 0 ? totalEarningArray[i - 1] : 0;
//                                     mileBonus = i > 0 ? bonusArray[i - 1] : 0;
//                                     entry = i > 0 ? studentArray[i - 1] : 0;
//                                     break;
//                                   }
//                                 }
//                               }
//
//                               print(
//                                   "Matched Total Earning: $matchedTotalEarning");
//                               print("Matched Milestone Bonus: $mileBonus");
//                               print("Matched entry: $entry");
//
//                               final normalizedValue =
//                               matchedTotalEarning.clamp(0, 5).toInt();
//                               print("Normalized Value: $normalizedValue");
//
//                               return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     NumberPickerFlutterWidget(
//                                         totalEarning:
//                                         matchedTotalEarning.toInt()),
//                                     Text(
//                                       'Milestone bonus =$mileBonus',
//                                       style: txtStyle.bonusTextColors,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                             'Enteries till next milestone=$entry'),
//                                         StepProgressIndicatorWidget(
//                                           value: normalizedValue,
//                                         )
//                                       ],
//                                     ),
//                                     const SizedBox(height: 20),
//                                     ButtonWidget(
//                                       onPressed: () {
//                                         print('Button pressed');
//                                         _navigateToWalletHistory();
//                                       },
//                                       title: "wallet history",
//                                     ),
//                                     const SizedBox(height: 20),
//                                   ]);
//                             } else {
//                               return const Text('NumberPicker is null');
//                             }
//                           } else {
//                             return const Text('No data found');
//                           }
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//
//       ),
//
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/pages/verificiation_otp_page.dart';
import 'package:exam/pages/wallet_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/grades_model.dart';
import '../utils/themes.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/elevated_button.dart';
import '../widgets/floating_chating_button.dart';
import '../widgets/home_page_grades.dart';
import '../widgets/numberpicker_widget.dart';
import '../widgets/step_progress.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> ids = [];
  List<String> bonus = [];
  List<String> totalEarning = [];
  GradeModel? gradeModel;
  int _totalEarning = 0;

  @override
  void initState() {
    super.initState();
    _fetchGrades();
    _fetchTotalEarning();
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
          });
        } else {
          print('No grades found.');
        }
      });
    } catch (e) {
      print('Failed to fetch grades: $e');
    }
  }

  Future<void> _fetchTotalEarning() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('rewardList')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final firstArray = data['first'] as List<dynamic>?;

        if (firstArray != null && firstArray.length > 5) {
          final totalEarning =
          (firstArray[5] as Map<String, dynamic>)['totalEarning'];
          setState(() {
            _totalEarning = totalEarning ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error fetching totalEarning: $e');
    }
  }

  void _navigateToWalletHistory() {
    print('Navigating to WalletHistory');
    print('IDs: $ids');
    print('Bonuses: $bonus');
    print('Total Earnings: $totalEarning');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WalletHistory(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Stream<DocumentSnapshot> streamRewardList() {
      if (_user == null) {
        return Stream.empty();
      }
      return _firestore.collection('rewardList').doc(_user.uid).snapshots();
    }

    TextStyling textStyling = TextStyling();

    return Scaffold(
      floatingActionButton: const FloatingChatingButton(),
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFFFFFF),
      drawer: const DrawerWidget(id: ''),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(
            scaffoldKey: scaffoldKey,
            id: _user?.uid ?? '',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const HomePageGrades(),
                    const SizedBox(height: 20),
                    StreamBuilder<DocumentSnapshot>(
                        stream: streamRewardList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print('Error in StreamBuilder: ${snapshot.error}');
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData &&
                              snapshot.data!.exists) {
                            final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                            final first =
                                data?['first'] as List<dynamic>? ?? [];

                            final bonusArray = first
                                .map((e) => e['bonus'] as num? ?? 0)
                                .toList();
                            final studentArray = first
                                .map((e) => e['student'] as num? ?? 0)
                                .toList();
                            final totalEarningArray = first
                                .map((e) => e['totalEarning'] as num? ?? 0)
                                .toList();

                            print('Bonus Array: $bonusArray');
                            print('Student Array: $studentArray');
                            print('Total Earning Array: $totalEarningArray');

                            final sixthBonusValue =
                            bonusArray.length > 5 ? bonusArray[5] : 0;
                            final nextEntry = studentArray.length > 6
                                ? studentArray[6] - studentArray[5]
                                : 0;

                            ids = studentArray
                                .map((id) => id.toString())
                                .toList();
                            bonus = bonusArray.map((b) => b.toString()).toList();
                            totalEarning = totalEarningArray.map((e) => e.toString()).toList();

                            if (gradeModel != null) {
                              double totalGradeSum = (gradeModel!.grade1 +
                                  gradeModel!.grade2 +
                                  gradeModel!.grade3) /
                                  3;
                              int roundedTotalGradeSum = totalGradeSum.floor();
                              print("Total Grade Sum: $totalGradeSum  : $roundedTotalGradeSum");

                              num matchedTotalEarning = 0;
                              num mileBonus = 0;
                              num entry = 0;
                              bool foundMatch = false;

                           //   bool foundMatch = false; // Initialize the flag

// Check for an exact match
                              for (int i = 0; i < studentArray.length; i++) {
                                if (studentArray[i] == roundedTotalGradeSum) {
                                  matchedTotalEarning = totalEarningArray[i];
                                  mileBonus = bonusArray[i];
                                  entry = studentArray[i];
                                  foundMatch = true;
                                  print("Exact match found. Total earning: $matchedTotalEarning");
                                  break;
                                }
                              }

// If no exact match is found, find the closest previous value
                              if (!foundMatch) {
                                for (int i = studentArray.length - 1; i >= 0; i--) { // Start from the end of the array
                                  if (roundedTotalGradeSum >= studentArray[i]) { // Find the first student ID less than or equal to totalGradeSum
                                    matchedTotalEarning = totalEarningArray[i];
                                    mileBonus = bonusArray[i];
                                    entry = studentArray[i];
                                    print("Matched total grade with sum is $matchedTotalEarning");
                                    break; // Exit the loop once the closest previous value is found
                                  }
                                }
                              }

// Debugging output for verification
                              if (!foundMatch) {
                                print("No exact match found. Closest previous value: $entry");
                              }




                              print(
                                  "Matched Total Earning: $matchedTotalEarning");
                              print("Matched Milestone Bonus: $mileBonus");
                              print("Matched entry: $entry");

                              final normalizedValue =
                              matchedTotalEarning.clamp(0, 5).toInt();
                              print("Normalized Value: $normalizedValue");

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NumberPickerFlutterWidget(
                                        totalEarning:
                                        matchedTotalEarning.toInt()),
                                    Text(
                                      'Milestone bonus =$mileBonus',
                                      style: txtStyle.bonusTextColors,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Entries till next milestone=$entry'),
                                        StepProgressIndicatorWidget(
                                          value: normalizedValue,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ButtonWidget(
                                      onPressed: () {
                                        print('Button pressed');
                                        _navigateToWalletHistory();
                                      },
                                      title: "wallet history",
                                    ),
                                    const SizedBox(height: 20),
                                  ]);
                            } else {
                              return const Text('NumberPicker is null');
                            }
                          } else {
                            return const Text('No data found');
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
