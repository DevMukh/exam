import 'dart:math'; // Import for random number generation
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/pages/receipt_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_bar_widget.dart';

class WalletHistory extends StatefulWidget {
  WalletHistory({Key? key}) : super(key: key);

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid; // Get the logged-in user's UID
    _initializeWalletHistory(); // Initialize wallet history on page load
    _listenForRewardListChanges(); // Set up listener for changes in rewardList
  }

  Future<void> _initializeWalletHistory() async {
    try {
      DocumentSnapshot rewardSnapshot = await _firestore.collection('rewardList').doc(userId).get();
      Map<String, dynamic>? userData = rewardSnapshot.data() as Map<String, dynamic>?;
      final first = userData?['first'] as List<dynamic>? ?? [];
      final students = first.map((e) => e['student'] ?? 0).toList();
      final bonus = first.map((e) => e['bonus'] ?? 0).toList();
      final totalEarning = first.map((e) => e['totalEarning'] ?? 0).toList();

      List<Map<String, dynamic>> rewards = [];
      for (int i = 0; i < students.length; i++) {
        rewards.add({
          'id': students[i].toString(),
          'status': 'Waiting',
          'dateOfRecival': Timestamp.now(),
          'viewReceipt': 'Waiting',
          'bonus': bonus[i].toString(),
          'totalEarning': totalEarning[i].toString(),
        });
      }

      // Check if the walletHistory document exists
      DocumentSnapshot walletSnapshot = await _firestore.collection('walletHistory').doc(userId).get();
      if (!walletSnapshot.exists) {
        // Create walletHistory document if it doesn't exist
        await _firestore.collection('walletHistory').doc(userId).set({
          'userId': userId,
          'rewards': rewards,
        });
      }
    } catch (e) {
      print('Error initializing wallet history: $e');
    }
  }

  Future<void> _updateReward(String id) async {
    try {
      // Fetch the current data from Firestore
      DocumentSnapshot docSnapshot = await _firestore.collection('walletHistory').doc(userId).get();
      Map<String, dynamic>? userData = docSnapshot.data() as Map<String, dynamic>?;
      List<dynamic> currentRewardsList = userData?['rewards'] ?? [];

      // Find the reward with the specified ID
      final rewardIndex = currentRewardsList.indexWhere((reward) => reward['id'] == id);
      if (rewardIndex == -1) return; // If the reward ID is not found

      Map<String, dynamic> existingReward = currentRewardsList[rewardIndex];
      bool isViewing = existingReward['viewReceipt'].toLowerCase() == 'waiting';

      existingReward = {
        'id': existingReward['id'],
        'status': isViewing ? 'Received' : 'Waiting',
        'dateOfRecival': isViewing ? Timestamp.now() : existingReward['dateOfRecival'],
        'viewReceipt': isViewing ? 'View' : 'Waiting',
        'bonus': existingReward['bonus'], // Use the bonus from the selected reward
        'totalEarning': existingReward['totalEarning'], // Use the total earning from the selected reward
      };

      // Update the rewards list with the modified reward
      List<Map<String, dynamic>> updatedRewards = List.from(currentRewardsList);
      updatedRewards[rewardIndex] = existingReward; // Update the specified entry

      // Update the data in Firestore
      await _firestore.collection('walletHistory').doc(userId).set({
        'userId': userId, // Ensure userId is included
        'rewards': updatedRewards,
      }, SetOptions(merge: true));

      print('Reward updated successfully for ID: $id');
    } catch (e) {
      print('Error updating reward: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> _fetchRewards() {
    return _firestore.collection('walletHistory').doc(userId).snapshots().map((snapshot) {
      Map<String, dynamic>? userData = snapshot.data();
      final rewards = (userData?['rewards'] as List<dynamic>? ?? []).map((e) => e as Map<String, dynamic>).toList();
      return rewards;
    });
  }

  // void _listenForRewardListChanges() {
  //   _firestore.collection('rewardList').doc(userId).snapshots().listen((snapshot) async {
  //     try {
  //       Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
  //       final first = userData?['first'] as List<dynamic>? ?? [];
  //       final students = first.map((e) => e['student'] ?? 0).toList();
  //       final bonus = first.map((e) => e['bonus'] ?? 0).toList();
  //       final totalEarning = first.map((e) => e['totalEarning'] ?? 0).toList();
  //
  //       List<Map<String, dynamic>> rewards = [];
  //       for (int i = 0; i < students.length; i++) {
  //         rewards.add({
  //           'id': students[i].toString(),
  //           'status': 'Waiting',
  //           'dateOfRecival': Timestamp.now(),
  //           'viewReceipt': 'Waiting',
  //           'bonus': bonus[i].toString(),
  //           'totalEarning': totalEarning[i].toString(),
  //         });
  //       }
  //
  //       // Update the walletHistory document with the latest values
  //       await _firestore.collection('walletHistory').doc(userId).set({
  //         'userId': userId, // Ensure userId is included
  //         'rewards': rewards,
  //       }, SetOptions(merge: true));
  //
  //       print('Wallet history updated automatically with the latest values.');
  //     } catch (e) {
  //       print('Error listening for changes in rewardList: $e');
  //     }
  //   });
  // }
  void _listenForRewardListChanges() {
    _firestore.collection('rewardList').doc(userId).snapshots().listen((snapshot) async {
      try {
        Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
        final first = userData?['first'] as List<dynamic>? ?? [];
        final students = first.map((e) => e['student'] ?? 0).toList();
        final bonus = first.map((e) => e['bonus'] ?? 0).toList();
        final totalEarning = first.map((e) => e['totalEarning'] ?? 0).toList();

        // Fetch current rewards from walletHistory
        DocumentSnapshot walletSnapshot = await _firestore.collection('walletHistory').doc(userId).get();
        Map<String, dynamic>? walletData = walletSnapshot.data() as Map<String, dynamic>?;
        List<dynamic> currentRewardsList = walletData?['rewards'] ?? [];

        List<Map<String, dynamic>> updatedRewards = [];
        for (int i = 0; i < students.length; i++) {
          Map<String, dynamic> updatedReward = {
            'id': students[i].toString(),
            'status': 'Waiting',
            'dateOfRecival': Timestamp.now(),
            'viewReceipt': 'Waiting',
            'bonus': bonus[i].toString(),
            'totalEarning': totalEarning[i].toString(),
          };

          // Check if the reward already exists
          final existingRewardIndex = currentRewardsList.indexWhere((reward) => reward['id'] == students[i].toString());
          if (existingRewardIndex != -1) {
            // Update only the fields that have changed
            updatedReward['status'] = currentRewardsList[existingRewardIndex]['status'];
            updatedReward['dateOfRecival'] = currentRewardsList[existingRewardIndex]['dateOfRecival'];
            updatedReward['viewReceipt'] = currentRewardsList[existingRewardIndex]['viewReceipt'];
          }

          updatedRewards.add(updatedReward);
        }

        // Update the walletHistory document with the latest values
        await _firestore.collection('walletHistory').doc(userId).set({
          'userId': userId, // Ensure userId is included
          'rewards': updatedRewards,
        }, SetOptions(merge: true));

        print('Wallet history updated automatically with the latest values.');
      } catch (e) {
        print('Error listening for changes in rewardList: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const AppBarWidget(
        title: 'Wallet History',
        backgroundColor: Color(0xFFF5F5F5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _fetchRewards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<Map<String, dynamic>> rewards = snapshot.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    backgroundBlendMode: BlendMode.softLight,
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                  ),
                  child: DataTable(
                    border: const TableBorder(
                      horizontalInside: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      verticalInside: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    columnSpacing: MediaQuery.of(context).size.width * 0.03,
                    dataRowHeight: 60,
                    headingRowHeight: 50,
                    columns: const [
                      DataColumn(label: Center(child: Text('Milestone'))),
                      DataColumn(label: Center(child: Text('Status of Reward'))),
                      DataColumn(label: Center(child: Text('Time of Recival'))),
                      DataColumn(label: Center(child: Text('View Receipt'))),
                    ],
                    rows: rewards.map((reward) {
                      return DataRow(
                        cells: [
                          DataCell(Center(child: Text(reward['id'].toString()))),
                          DataCell(Center(
                              child: Text(
                                reward['status'],
                                style: TextStyle(
                                  color: reward['status'].toLowerCase() == 'received'
                                      ? const Color(0xff029E21)
                                      : const Color(0xffFFB038),
                                ),
                              ))),
                          DataCell(Center(
                            child: Text(
                              reward['status'].toLowerCase() == 'received'
                                  ? DateFormat('HH:mm:ss').format((reward['dateOfRecival'] as Timestamp).toDate())
                                  : 'Waiting',
                              style: TextStyle(
                                color: reward['status'].toLowerCase() == 'waiting' ? Colors.orange : Colors.black,
                              ),
                            ),
                          )),
                          DataCell(Center(
                            child: InkWell(
                              onTap: () {
                                if (reward['viewReceipt'].toLowerCase() == 'waiting') {
                                  print('Changing status for ID: ${reward['id']}');
                                  _updateReward(reward['id']); // Pass the ID of the selected reward
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ReceiptPage(),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                reward['viewReceipt'],
                                style: TextStyle(
                                  color: reward['viewReceipt'].toLowerCase() == 'waiting'
                                      ? Colors.orange
                                      : Colors.black,
                                ),
                              ),
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
