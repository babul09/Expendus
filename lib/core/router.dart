import 'package:go_router/go_router.dart';
import 'package:expen/firebase/auth_service.dart';
import 'package:expen/pages/home.dart';
import 'package:expen/pages/chart.dart';
import 'package:expen/pages/add_expense.dart';
import 'package:expen/pages/settings.dart';
import 'package:expen/pages/about.dart';
import 'package:expen/pages/login_page.dart';
import 'package:expen/pages/signup_page.dart';
import 'package:expen/pages/profile_page.dart';
import 'package:expen/pages/migration_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Go router configuration
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// Define the routes that require authentication
final List<String> _authenticatedRoutes = [
  '/',
  '/chart',
  '/addexpense',
  '/settings',
  '/profile',
  '/migration',
  '/about',
];

// Custom page transition builder for a modern, snappy animation
CustomTransitionPage<void> _buildPageTransition(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Use a combination of slide and fade for a snappy modern feel
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic, // More snappy curve
      );
      
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 250), // Faster transition
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  // Redirect to login if not authenticated
  redirect: (context, state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.isLoggedIn;
    final isOnLoginPage = state.uri.path == '/login';
    final isOnSignupPage = state.uri.path == '/signup';
    
    // If the user is not logged in and trying to access an authenticated route,
    // redirect to the login page
    if (!isLoggedIn && _authenticatedRoutes.contains(state.uri.path)) {
      return '/login';
    }
    
    // If the user is logged in and on the login page or signup page,
    // redirect to the home page
    if (isLoggedIn && (isOnLoginPage || isOnSignupPage)) {
      return '/';
    }
    
    // No redirect needed
    return null;
  },
  // Redirect to the home page if a navigation error occurs
  errorBuilder: (context, state) => const Home(),
  routes: [
    GoRoute(
      // Home Screen
      path: '/',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const Home()),
    ),
    GoRoute(
      // Chart Screen
      path: '/chart',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const Chart()),
    ),
    GoRoute(
      // Adding Expense Screen
      path: '/addexpense',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const AddExpense()),
    ),
    GoRoute(
      // Settings Screen
      path: '/settings',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const Settings()),
    ),
    GoRoute(
      // About Screen
      path: '/about',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const About()),
    ),
    GoRoute(
      // Migration Screen
      path: '/migration',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const MigrationPage()),
    ),
    GoRoute(
      // Profile Screen
      path: '/profile',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const ProfilePage()),
    ),
    GoRoute(
      // Login Screen
      path: '/login',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const LoginPage()),
    ),
    GoRoute(
      // Signup Screen
      path: '/signup',
      pageBuilder: (context, state) => _buildPageTransition(context, state, const SignupPage()),
    ),
  ],
);
