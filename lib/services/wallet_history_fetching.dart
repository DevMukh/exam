import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreWalletServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getWalletHistory(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('exam')
          .doc('Profile')
          .collection('RegisterUser')
          .doc(phoneNumber)
          .collection('walletHistory')
          .get();

      List<Map<String, dynamic>> rewardsHistory = [];
      for (var doc in querySnapshot.docs) {
        // Add document ID to each document's data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id; // Add the document ID to the data
        rewardsHistory.add(data);
      }
      print('Fetched rewards with IDs: $rewardsHistory');
      return rewardsHistory;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

}
