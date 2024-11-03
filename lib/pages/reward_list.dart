// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:exam/pages/home_page.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/reward_list_fetch_service.dart';
// import '../utils/themes.dart';
// import '../widgets/app_bar_widget.dart';
// import 'wallet_history.dart';
//
// class RewardList extends StatefulWidget {
//   const RewardList({super.key});
//
//   @override
//   _RewardListState createState() => _RewardListState();
// }
//
// class _RewardListState extends State<RewardList> {
//   final User? user = FirebaseAuth.instance.currentUser;
//   int? selectedRowIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     // Ensure the user's document exists and is initialized
//     FirestoreService().createUserDocumentIfNotExists();
//   }
//
//   void _navigateToWalletHistory(List<String> ids) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => WalletHistory(
//           // ids: [], bonus: [], totalEarning: [],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppColors appColors = AppColors();
//
//     return Scaffold(
//       backgroundColor: appColors.backgroundColors,
//       appBar: AppBarWidget(
//         title: 'Reward List',
//         backgroundColor: const Color(0xFFFFFFFF),
//         leadingIcon: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                   context, MaterialPageRoute(builder: (_) => HomePage()));
//             },
//             icon: const Icon(Icons.arrow_back_rounded)),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('rewardList')
//             .doc(user?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('No rewards found'));
//           } else {
//             final data = snapshot.data!.data() as Map<String, dynamic>;
//             final first = data['first'] as List<dynamic>? ?? [];
//             final students = first.map((e) => e['student'] ?? 0).toList();
//             final bonus = first.map((e) => e['bonus'] ?? 0).toList();
//             final totalEarning =
//                 first.map((e) => e['totalEarning'] ?? 0).toList();
//
//             if (students.isEmpty) {
//               return const Center(child: Text('No students data available'));
//             }
//
//             final int rowCount = students.length;
//             print(rowCount);
//             return Center(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: appColors.colorStroke),
//                   ),
//                   child: DataTable(
//                     dataRowHeight: 40,
//                     columnSpacing: 40,
//                     dividerThickness: 1,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: appColors.colorStroke)),
//                     dataTextStyle: const TextStyle(
//                         color: Color(0xff1a1818), fontWeight: FontWeight.bold),
//                     border: TableBorder(
//                       horizontalInside:
//                           BorderSide(color: appColors.colorStroke, width: 1),
//                       verticalInside:
//                           BorderSide(color: appColors.colorStroke, width: 1),
//                     ),
//                     headingTextStyle: const TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.bold),
//                     columns: const [
//                       DataColumn(label: Text('Students')),
//                       DataColumn(label: Text('Bonus')),
//                       DataColumn(label: Text('Total')),
//                     ],
//                     rows: List<DataRow>.generate(
//                       rowCount,
//                       (rowIndex) {
//                         return DataRow(
//                           color: WidgetStateProperty.resolveWith<Color?>(
//                             (Set<WidgetState> states) {
//                               if (selectedRowIndex == rowIndex) {
//                                 return const Color(0xffDFF5DE);
//                               }
//                               return const Color(0xFFFFFFFF);
//                             },
//                           ),
//                           cells: [
//                             DataCell(
//                               Text(students[rowIndex].toString()),
//                               onTap: () {
//                                 setState(() {
//                                   selectedRowIndex = rowIndex;
//                                   if (kDebugMode) {
//                                     print('Selected row: $rowIndex');
//                                   }
//                                   const startIndex = 0;
//                                   // final endIndex = startIndex + 6; // Get 6 items (current + 5 more)
//                                   final endIndex = rowCount;
//                                   final ids = students
//                                       .sublist(startIndex,
//                                           endIndex.clamp(0, students.length))
//                                       .map<String>((id) => id.toString())
//                                       .toList();
//
//                                   // Debug print
//                                   if (kDebugMode) {
//                                     print('IDs to be passed: $ids');
//                                   }
//
//                                //   _navigateToWalletHistory(ids);
//                                 });
//                               },
//                             ),
//                             DataCell(
//                               Text(bonus.isNotEmpty
//                                   ? bonus[rowIndex].toString()
//                                   : 'N/A'),
//                               onTap: () {
//                                 setState(() {
//                                   selectedRowIndex = rowIndex;
//                                   if (kDebugMode) {
//                                     print('Selected row: $rowIndex');
//                                   }
//                                 });
//                               },
//                             ),
//                             DataCell(
//                               Text(totalEarning.isNotEmpty
//                                   ? totalEarning[rowIndex].toString()
//                                   : 'N/A'),
//                               onTap: () {
//                                 setState(() {
//                                   selectedRowIndex = rowIndex;
//                                   if (kDebugMode) {
//                                     print('Selected row: $rowIndex');
//                                   }
//                                 });
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/reward_list_fetch_service.dart';
import '../utils/themes.dart';
import '../widgets/app_bar_widget.dart';
import 'wallet_history.dart';

class RewardList extends StatefulWidget {
  const RewardList({super.key});

  @override
  _RewardListState createState() => _RewardListState();
}

class _RewardListState extends State<RewardList> {
  final User? user = FirebaseAuth.instance.currentUser;
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    // Ensure the user's document exists and is initialized
    FirestoreService().createUserDocumentIfNotExists();
  }

  void _navigateToWalletHistory(List<String> ids) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WalletHistory(
          // ids: [], bonus: [], totalEarning: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();

    return Scaffold(
      backgroundColor: appColors.backgroundColors,
      appBar: AppBarWidget(
        title: 'Reward List',
        backgroundColor: const Color(0xFFFFFFFF),
        leadingIcon: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rewardList')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No rewards found'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final first = data['first'] as List<dynamic>? ?? [];
            final students = first.map((e) => e['student'] ?? 0).toList();
            final bonus = first.map((e) => e['bonus'] ?? 0).toList();
            final totalEarning =
            first.map((e) => e['totalEarning'] ?? 0).toList();

            if (students.isEmpty) {
              return const Center(child: Text('No students data available'));
            }

            // Sort the students and reorder bonus and totalEarning accordingly
            final indices = List<int>.generate(students.length, (index) => index);
            indices.sort((a, b) => students[a].compareTo(students[b]));

            final sortedStudents = [for (var index in indices) students[index]];
            final sortedBonus = [for (var index in indices) bonus[index]];
            final sortedTotalEarning = [for (var index in indices) totalEarning[index]];

            final int rowCount = sortedStudents.length;

            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appColors.colorStroke),
                  ),
                  child: DataTable(
                    dataRowHeight: 40,
                    columnSpacing: 40,
                    dividerThickness: 1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: appColors.colorStroke)),
                    dataTextStyle: const TextStyle(
                        color: Color(0xff1a1818), fontWeight: FontWeight.bold),
                    border: TableBorder(
                      horizontalInside:
                      BorderSide(color: appColors.colorStroke, width: 1),
                      verticalInside:
                      BorderSide(color: appColors.colorStroke, width: 1),
                    ),
                    headingTextStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    columns: const [
                      DataColumn(label: Text('Students')),
                      DataColumn(label: Text('Bonus')),
                      DataColumn(label: Text('Total')),
                    ],
                    rows: List<DataRow>.generate(
                      rowCount,
                          (rowIndex) {
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (selectedRowIndex == rowIndex) {
                                return const Color(0xffDFF5DE);
                              }
                              return const Color(0xFFFFFFFF);
                            },
                          ),
                          cells: [
                            DataCell(
                              Text(sortedStudents[rowIndex].toString()),
                              onTap: () {
                                setState(() {
                                  selectedRowIndex = rowIndex;
                                  if (kDebugMode) {
                                    print('Selected row: $rowIndex');
                                  }
                                  const startIndex = 0;
                                  final endIndex = rowCount;
                                  final ids = sortedStudents
                                      .sublist(startIndex,
                                      endIndex.clamp(0, sortedStudents.length))
                                      .map<String>((id) => id.toString())
                                      .toList();

                                  if (kDebugMode) {
                                    print('IDs to be passed: $ids');
                                  }

                                  // _navigateToWalletHistory(ids);
                                });
                              },
                            ),
                            DataCell(
                              Text(sortedBonus.isNotEmpty
                                  ? sortedBonus[rowIndex].toString()
                                  : 'N/A'),
                              onTap: () {
                                setState(() {
                                  selectedRowIndex = rowIndex;
                                  if (kDebugMode) {
                                    print('Selected row: $rowIndex');
                                  }
                                });
                              },
                            ),
                            DataCell(
                              Text(sortedTotalEarning.isNotEmpty
                                  ? sortedTotalEarning[rowIndex].toString()
                                  : 'N/A'),
                              onTap: () {
                                setState(() {
                                  selectedRowIndex = rowIndex;
                                  if (kDebugMode) {
                                    print('Selected row: $rowIndex');
                                  }
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
