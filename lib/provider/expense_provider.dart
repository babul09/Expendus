import 'package:flutter/foundation.dart';
import 'package:expen/firebase/expense_model.dart';
import 'package:expen/firebase/expense_repository.dart';
import 'package:expen/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _repository = ExpenseRepository();
  final FirebaseService _firebaseService = FirebaseService();
  List<FirebaseExpense> _expenses = [];
  bool _isLoading = false;
  String? _error;
  bool _firebaseAvailable = false;
  
  // Auth state
  User? get currentUser => _firebaseService.currentUser;
  bool get isAuthenticated => _firebaseService.isAuthenticated;

  // Getters
  List<FirebaseExpense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get firebaseAvailable => _firebaseAvailable;

  // Constructor to initialize
  ExpenseProvider() {
    _initializeFirebase();
    // Don't try to load expenses here - wait for successful initialization and auth
  }

  // Initialize Firebase
  Future<void> _initializeFirebase() async {
    try {
      // We don't need to call initializeFirebase() again here - it's done in main.dart
      // Just check if Firebase is available
      _firebaseAvailable = true;
      
      // Only load expenses if user is authenticated
      if (_firebaseService.isAuthenticated) {
        await loadExpenses();
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Firebase initialization failed: $e';
      _firebaseAvailable = false;
      notifyListeners();
      debugPrint(_error);
    }
  }

  // Load all expenses
  Future<void> loadExpenses() async {
    if (!_firebaseAvailable) {
      _error = 'Firebase is not available';
      notifyListeners();
      return;
    }
    
    if (!isAuthenticated) {
      _error = 'User must be authenticated to load expenses';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _repository.getExpenses().listen(
        (expensesList) {
          _expenses = expensesList;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Failed to load expenses: $e';
          _isLoading = false;
          notifyListeners();
          debugPrint(_error);
        },
      );
    } catch (e) {
      _error = 'Failed to initialize expense stream: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint(_error);
    }
  }

  // Load expenses for a specific time range
  Future<void> loadExpensesForTimeframe(DateTime start, DateTime end) async {
    if (!_firebaseAvailable) {
      _error = 'Firebase is not available';
      notifyListeners();
      return;
    }
    
    if (!isAuthenticated) {
      _error = 'User must be authenticated to load expenses';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _repository.getExpensesForTimeframe(start, end).listen(
        (expensesList) {
          _expenses = expensesList;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Failed to load expenses: $e';
          _isLoading = false;
          notifyListeners();
          debugPrint(_error);
        },
      );
    } catch (e) {
      _error = 'Failed to initialize expense stream: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint(_error);
    }
  }

  // Add expense
  Future<void> addExpense({
    required String name,
    required double amount,
    required DateTime date,
    required String category,
    String? note,
  }) async {
    if (!_firebaseAvailable) {
      _error = 'Firebase is not available';
      notifyListeners();
      return;
    }
    
    if (!isAuthenticated) {
      _error = 'User must be authenticated to add expenses';
      notifyListeners();
      return;
    }

    try {
      await _repository.addExpense(
        name: name,
        amount: amount,
        date: date,
        category: category,
        note: note,
      );
    } catch (e) {
      _error = 'Failed to add expense: $e';
      notifyListeners();
      debugPrint(_error);
      rethrow;
    }
  }

  // Update expense
  Future<void> updateExpense(FirebaseExpense expense) async {
    if (!_firebaseAvailable) {
      _error = 'Firebase is not available';
      notifyListeners();
      return;
    }
    
    if (!isAuthenticated) {
      _error = 'User must be authenticated to update expenses';
      notifyListeners();
      return;
    }

    try {
      await _repository.updateExpense(expense);
    } catch (e) {
      _error = 'Failed to update expense: $e';
      notifyListeners();
      debugPrint(_error);
      rethrow;
    }
  }

  // Delete expense
  Future<void> deleteExpense(String expenseId) async {
    if (!_firebaseAvailable) {
      _error = 'Firebase is not available';
      notifyListeners();
      return;
    }
    
    if (!isAuthenticated) {
      _error = 'User must be authenticated to delete expenses';
      notifyListeners();
      return;
    }

    try {
      await _repository.deleteExpense(expenseId);
    } catch (e) {
      _error = 'Failed to delete expense: $e';
      notifyListeners();
      debugPrint(_error);
      rethrow;
    }
  }

  // Migrate data from Hive to Firebase
  Future<void> migrateFromHiveToFirebase() async {
    if (!_firebaseAvailable) {
      _error = 'Firebase is not available';
      notifyListeners();
      throw Exception('Firebase is not available');
    }
    
    if (!isAuthenticated) {
      _error = 'User must be authenticated to migrate data';
      notifyListeners();
      throw Exception('User must be authenticated to migrate data');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.migrateFromHive();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to migrate data: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint(_error);
      rethrow;
    }
  }
} 