import 'package:expen/core/theme.dart';
import 'package:expen/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final int currentIndex;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final bool showBackButton;

  const AppScaffold({
    super.key,
    required this.body,
    this.title = '',
    this.actions,
    required this.currentIndex,
    this.floatingActionButton,
    this.showAppBar = true,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Handler for back button/gesture
    Future<bool> _onWillPop() async {
      // If we can pop the current route, let it happen
      if (Navigator.of(context).canPop()) {
        return true;  // Allow the pop
      }
      
      // If we're on a main page (not home), navigate to home
      if (GoRouterState.of(context).matchedLocation != '/') {
        GoRouter.of(context).go('/');
        return false;  // Prevent the system pop
      }
      
      // We're on the home page, show exit confirmation
      final exitConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Exit Expendus?'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Exit',
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ],
        ),
      ) ?? false;
      
      if (exitConfirmed) {
        // Only use this in Android
        SystemNavigator.pop();
      }
      
      return false;  // Prevent the default system pop
    }
    
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        appBar: showAppBar
            ? AppBar(
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                backgroundColor: isDarkMode ? AppColors.black : AppColors.primary,
                elevation: 0,
                actions: actions,
                leading: showBackButton 
                  ? GestureDetector(
                      onTap: () {
                        // Check if we can pop before attempting to
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        } else {
                          // If we can't pop, navigate to home instead
                          context.go('/');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.black26 
                              : AppColors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.arrow_back_ios, 
                            color: isDarkMode ? AppColors.primaryDark : AppColors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        context.push('/profile');
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.black26 
                              : AppColors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.person, 
                          color: isDarkMode ? AppColors.primaryDark : AppColors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                leadingWidth: 56,
              )
            : null,
        body: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.primary,
          ),
          child: body,
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: currentIndex),
      ),
    );
  }
} 