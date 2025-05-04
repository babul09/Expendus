import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // For Android, just use the default constructor without clientId
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  // Auth state
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  User? get user => _user ?? _auth.currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => user != null;
  
  // Constructor to initialize and listen to auth state changes
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in flow
        _isLoading = false;
        notifyListeners();
        return null;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      
      _isLoading = false;
      notifyListeners();
      return _user;
    } catch (e) {
      _error = 'Failed to sign in with Google: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint(_error);
      return null;
    }
  }
  
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      
      _isLoading = false;
      notifyListeners();
      return _user;
    } catch (e) {
      _error = 'Failed to sign in with email and password: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint(_error);
      return null;
    }
  }
  
  // Create user with email and password
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      
      _isLoading = false;
      notifyListeners();
      return _user;
    } catch (e) {
      _error = 'Failed to create user: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint(_error);
      return null;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
    } catch (e) {
      _error = 'Failed to sign out: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _error = 'Failed to send password reset email: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 