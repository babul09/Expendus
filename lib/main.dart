import 'dart:ui';

import 'package:expen/core/providers.dart';
import 'package:expen/core/router.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/firebase/firebase_service.dart';
import 'package:expen/hive/backup_and_reset.dart';
import 'package:expen/hive/hive_database.dart';
import 'package:expen/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Entry point of app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - only do this in main.dart
  final firebaseService = FirebaseService();
  bool firebaseInitialized = false;
  try {
    await firebaseService.initializeFirebase();
    firebaseInitialized = true;
    debugPrint('Firebase initialization completed in main.dart');
  } catch (e) {
    debugPrint('Failed to initialize Firebase in main.dart: $e');
    // Continue with app initialization even if Firebase fails
  }

  // Initialize Hive (kept for backward compatibility and data migration)
  await Hive.initFlutter();
  Hive.registerAdapter(AmountAdapter());

  try {
    await Hive.openBox<Amount>("expenses");
  } catch (e) {
    await backupAndResetHive();
  }

  // Listen for auth state changes
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    debugPrint('Auth state changed: ${user != null ? 'User logged in' : 'User logged out'}');
  });

  PlatformDispatcher.instance.onPlatformConfigurationChanged = () {};
  runApp(appProvider(MyApp(firebaseInitialized: firebaseInitialized)));

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.transparent,
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

// Custom light theme based on the image
ThemeData _getLightTheme() {
  return ThemeData.light().copyWith(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: AppColors.black),
    ),
    cardTheme: CardTheme(
      color: AppColors.cardBg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.2),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.black),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondaryYellow,
      surface: AppColors.cardBg,
      background: AppColors.primary,
      error: AppColors.red,
    ),
    splashColor: AppColors.transparent,
    highlightColor: AppColors.transparent,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryYellow,
      foregroundColor: AppColors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.secondaryYellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryYellow,
        foregroundColor: AppColors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.secondaryYellow, width: 2),
      ),
    ),
  );
}

// Dark theme based on the image but with dark background
ThemeData _getDarkTheme() {
  return ThemeData.dark().copyWith(
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primaryDark),
    ),
    cardTheme: CardTheme(
      color: Color.fromRGBO(30, 30, 30, 1),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryYellow,
      surface: Color.fromRGBO(30, 30, 30, 1),
      background: AppColors.black,
      error: AppColors.red,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryYellow,
      foregroundColor: AppColors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryYellow,
        foregroundColor: AppColors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromRGBO(45, 45, 45, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
    ),
    splashColor: AppColors.transparent,
    highlightColor: AppColors.transparent,
  );
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;
  
  const MyApp({
    super.key, 
    this.firebaseInitialized = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme mode from provider
    var themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior(),
      title: "Expendus",
      theme: _getLightTheme(),
      darkTheme: _getDarkTheme(),
      themeMode: themeProvider.themeMode,
      routerConfig: router,
    );
  }
}
