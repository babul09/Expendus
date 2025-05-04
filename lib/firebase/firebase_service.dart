import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  FirebaseFirestore? _firestore;
  FirebaseAuth? _auth;
  bool _initialized = false;

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    if (_initialized) {
      debugPrint('Firebase already initialized, using existing instances');
      return;
    }

    try {
      // Check if Firebase is already initialized
      FirebaseApp? app;
      try {
        app = Firebase.app();
        debugPrint('Firebase was already initialized with app: ${app.name}');
      } catch (e) {
        // Firebase not initialized yet, continue with initialization
        debugPrint('Firebase not initialized yet, initializing now');
        app = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      // Set the Firestore and Auth instances
      _firestore = FirebaseFirestore.instance;
      _auth = FirebaseAuth.instance;
      _initialized = true;
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Get Firestore instance
  FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw StateError('Firebase must be initialized before accessing Firestore');
    }
    return _firestore!;
  }

  // Get Auth instance
  FirebaseAuth get auth {
    if (_auth == null) {
      throw StateError('Firebase must be initialized before accessing Auth');
    }
    return _auth!;
  }

  // Get current user ID or throw if not authenticated
  String get currentUserId {
    final user = auth.currentUser;
    if (user == null) {
      throw StateError('User must be authenticated to access this resource');
    }
    return user.uid;
  }

  // Get current user or null if not authenticated
  User? get currentUser => auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => auth.currentUser != null;

  // Collection reference for a user's expenses
  CollectionReference getUserExpensesCollection() {
    return firestore.collection('users/${currentUserId}/expenses');
  }

  // Add expense document for the current user
  Future<DocumentReference> addExpense(Map<String, dynamic> expenseData) async {
    return await getUserExpensesCollection().add(expenseData);
  }

  // Get all expenses for the current user
  Stream<QuerySnapshot> getExpensesStream() {
    return getUserExpensesCollection().orderBy('date', descending: true).snapshots();
  }

  // Get expenses for a specific timeframe for the current user
  Stream<QuerySnapshot> getExpensesForTimeframe(DateTime startDate, DateTime endDate) {
    return getUserExpensesCollection()
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Update expense for the current user
  Future<void> updateExpense(String docId, Map<String, dynamic> updatedData) async {
    return await getUserExpensesCollection().doc(docId).update(updatedData);
  }

  // Delete expense for the current user
  Future<void> deleteExpense(String docId) async {
    return await getUserExpensesCollection().doc(docId).delete();
  }

  // Migration: Move data from Hive to the authenticated user's Firebase collection
  Future<void> migrateHiveDataToUserAccount(List<Map<String, dynamic>> expenses) async {
    if (!isAuthenticated) {
      throw StateError('User must be authenticated to migrate data');
    }

    final batch = firestore.batch();
    final collectionRef = getUserExpensesCollection();
    
    for (final expenseData in expenses) {
      batch.set(collectionRef.doc(), expenseData);
    }
    
    await batch.commit();
    debugPrint('Migration to user account completed successfully');
  }
} 