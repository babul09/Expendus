import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpense {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String category;
  final String? note;

  FirebaseExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  // Create from Firestore document
  factory FirebaseExpense.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FirebaseExpense(
      id: doc.id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? 'Other',
      note: data['note'],
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'category': category,
      'note': note,
    };
  }

  // Convert from Hive Amount model (will need to be implemented)
  static FirebaseExpense fromHiveAmount(dynamic hiveAmount, String id) {
    // This method would convert from your Hive model to Firebase model
    // Implementation depends on your Hive model structure
    return FirebaseExpense(
      id: id,
      name: hiveAmount.name,
      amount: hiveAmount.amount,
      date: hiveAmount.dateTime,
      category: hiveAmount.category,
      note: hiveAmount.note,
    );
  }
} 