import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expen/firebase/expense_model.dart';
import 'package:expen/firebase/firebase_service.dart';
import 'package:expen/hive/hive_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class ExpenseRepository {
  final FirebaseService _firebaseService = FirebaseService();
  
  // Check if user is authenticated
  bool get isAuthenticated => _firebaseService.isAuthenticated;
  
  // Get stream of expenses for authenticated user
  Stream<List<FirebaseExpense>> getExpenses() {
    if (!isAuthenticated) {
      // Return empty stream if not authenticated
      return Stream.value([]);
    }
    
    return _firebaseService.getExpensesStream().map((QuerySnapshot query) {
      return query.docs.map((doc) => FirebaseExpense.fromFirestore(doc)).toList();
    });
  }
  
  // Get expenses for a specific timeframe for authenticated user
  Stream<List<FirebaseExpense>> getExpensesForTimeframe(DateTime start, DateTime end) {
    if (!isAuthenticated) {
      // Return empty stream if not authenticated
      return Stream.value([]);
    }
    
    return _firebaseService.getExpensesForTimeframe(start, end).map((QuerySnapshot query) {
      return query.docs.map((doc) => FirebaseExpense.fromFirestore(doc)).toList();
    });
  }
  
  // Add a new expense for authenticated user
  Future<String> addExpense({
    required String name,
    required double amount,
    required DateTime date,
    required String category,
    String? note,
  }) async {
    if (!isAuthenticated) {
      throw StateError('User must be authenticated to add expenses');
    }
    
    try {
      DocumentReference docRef = await _firebaseService.addExpense({
        'name': name,
        'amount': amount,
        'date': Timestamp.fromDate(date),
        'category': category,
        'note': note,
      });
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding expense: $e');
      rethrow;
    }
  }
  
  // Update expense for authenticated user
  Future<void> updateExpense(FirebaseExpense expense) async {
    if (!isAuthenticated) {
      throw StateError('User must be authenticated to update expenses');
    }
    
    try {
      await _firebaseService.updateExpense(expense.id, expense.toFirestore());
    } catch (e) {
      debugPrint('Error updating expense: $e');
      rethrow;
    }
  }
  
  // Delete expense for authenticated user
  Future<void> deleteExpense(String expenseId) async {
    if (!isAuthenticated) {
      throw StateError('User must be authenticated to delete expenses');
    }
    
    try {
      await _firebaseService.deleteExpense(expenseId);
    } catch (e) {
      debugPrint('Error deleting expense: $e');
      rethrow;
    }
  }
  
  // Migrate data from Hive to Firebase for authenticated user
  Future<void> migrateFromHive() async {
    if (!isAuthenticated) {
      throw StateError('User must be authenticated to migrate data');
    }
    
    try {
      // Open Hive box if not already open
      final box = await Hive.openBox<Amount>('expenses');
      final expenses = <Map<String, dynamic>>[];
      
      // Convert all Hive expenses to Firestore data
      for (int i = 0; i < box.length; i++) {
        final amount = box.getAt(i);
        
        if (amount != null) {
          // Convert to Firebase data format
          final firebaseData = FirebaseExpense.fromHiveAmount(amount, i.toString()).toFirestore();
          expenses.add(firebaseData);
        }
      }
      
      // Migrate data to user's account
      await _firebaseService.migrateHiveDataToUserAccount(expenses);
      debugPrint('Migration from Hive to Firebase completed successfully');
    } catch (e) {
      debugPrint('Error migrating data from Hive to Firebase: $e');
      rethrow;
    }
  }
} 