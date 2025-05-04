import 'package:expen/firebase/auth_service.dart';
import 'package:expen/widgets/app_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return AppScaffold(
      currentIndex: -1, // No item selected in bottom nav since Profile is now in AppBar
      title: "Profile",
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Profile picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 70, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 24),
            
            // User name
            Text(
              user?.displayName ?? 'User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            // User email
            Text(
              user?.email ?? 'No email provided',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 40),
            const Divider(),
            
            // Account information section
            _buildSection(
              icon: Icons.person,
              title: 'Account Information',
              onTap: () {
                // Navigate to account information page
              },
            ),
            
            // Security section
            _buildSection(
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                // Navigate to security page
              },
            ),
            
            // Data & Privacy section
            _buildSection(
              icon: Icons.privacy_tip,
              title: 'Data & Privacy',
              onTap: () {
                // Navigate to privacy page
              },
            ),
            
            const SizedBox(height: 40), // Added more space before sign out button
            
            // Sign out button
            ElevatedButton.icon(
              onPressed: authService.isLoading
                  ? null
                  : () => _signOut(context, authService),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 24), // Added bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _signOut(BuildContext context, AuthService authService) async {
    try {
      await authService.signOut();
      if (context.mounted) {
        // Navigate to login page after signing out
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }
} 