// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FirestoreServiceWalletHistory {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // Collection path for rewards
//   String get _rewardsCollection => 'rewards';
//
//   // Method to update a single reward
//   Future<void> updateReward(String id, String status, String dateOfRecival, String viewReceipt) async {
//     try {
//       // Update the reward document with the given ID
//       await _db.collection(_rewardsCollection).doc(id).update({
//         'status': status,
//         'dateOfRecival': dateOfRecival,
//         'viewReceipt': viewReceipt,
//       });
//       print('Reward updated successfully');
//     } catch (e) {
//       print('Error updating reward: $e');
//     }
//   }
//
//   // Method to update multiple rewards
//   Future<void> updateRewards(List<List<dynamic>> rewards) async {
//     final batch = _db.batch();
//
//     for (var reward in rewards) {
//       final docRef = _db.collection(_rewardsCollection).doc(reward[0].toString()); // ID is at index 0
//       batch.update(docRef, {
//         'status': reward[1].toString(),        // Status is at index 1
//         'dateOfRecival': reward[2].toString(),  // Date is at index 2
//         'viewReceipt': reward[3].toString(),    // View receipt is at index 3
//       });
//     }
//
//     try {
//       await batch.commit();
//       print('Rewards updated successfully');
//     } catch (e) {
//       print('Error updating rewards: $e');
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceWalletHistory {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection paths for rewards and wallet history
  String get _rewardsCollection => 'rewards';
  String get _walletHistoryCollection => 'walletHistory';

  // Method to update a single reward and store the history
  Future<void> updateReward(String id, String status, String dateOfRecival, String viewReceipt) async {
    try {
      // Update the reward document with the given ID
      await _db.collection(_rewardsCollection).doc(id).update({
        'status': status,
        'dateOfRecival': dateOfRecival,
        'viewReceipt': viewReceipt,
      });

      // Store the updated reward in the walletHistory collection
      await storeRewardInHistory(id, status, dateOfRecival, viewReceipt);

      print('Reward updated and history recorded successfully');
    } catch (e) {
      print('Error updating reward: $e');
    }
  }

  // Method to update multiple rewards and store the history
  Future<void> updateRewards(List<List<dynamic>> rewards) async {
    final batch = _db.batch();

    for (var reward in rewards) {
      final docRef = _db.collection(_rewardsCollection).doc(reward[0].toString()); // ID is at index 0
      batch.update(docRef, {
        'status': reward[1].toString(),        // Status is at index 1
        'dateOfRecival': reward[2].toString(),  // Date is at index 2
        'viewReceipt': reward[3].toString(),    // View receipt is at index 3
      });

      // Add the reward to the walletHistory collection
      _addRewardToHistoryBatch(batch, reward[0].toString(), reward[1].toString(), reward[2].toString(), reward[3].toString());
    }

    try {
      await batch.commit();
      print('Rewards updated and history recorded successfully');
    } catch (e) {
      print('Error updating rewards: $e');
    }
  }

  // Helper method to store a single reward in the walletHistory collection
  Future<void> storeRewardInHistory(String id, String status, String dateOfRecival, String viewReceipt) async {
    try {
      await _db.collection(_walletHistoryCollection).add({
        'id': id,
        'status': status,
        'dateOfRecival': dateOfRecival,
        'viewReceipt': viewReceipt,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for when the record was added
      });
    } catch (e) {
      print('Error storing reward in history: $e');
    }
  }

  // Helper method to add rewards to the walletHistory batch
  void _addRewardToHistoryBatch(
      WriteBatch batch, String id, String status, String dateOfRecival, String viewReceipt
      ) {
    final docRef = _db.collection(_walletHistoryCollection).doc(); // Create a new document
    batch.set(docRef, {
      'id': id,
      'status': status,
      'dateOfRecival': dateOfRecival,
      'viewReceipt': viewReceipt,
      'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for when the record was added
    });
  }
}
