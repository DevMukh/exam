import 'package:cloud_firestore/cloud_firestore.dart';

class WalletHistory {
  final List<String> ID; // List of IDs
  final bool status;     // Single boolean for status
  final bool view;       // Single boolean for view
  final DateTime? dateAndTime; // Optional DateTime for tracking

  WalletHistory({
    required this.ID,
    required this.status,
    required this.view,
    this.dateAndTime,
  });

  factory WalletHistory.fromMap(Map<String, dynamic> map) {
    return WalletHistory(
      ID: List<String>.from(map['ids'] ?? []),
      status: map['status'] ?? false,
      view: map['view'] ?? false,
      dateAndTime: map['dateAndTime'] != null
          ? (map['dateAndTime'] as Timestamp).toDate()
          : null,
    );
  }
}
