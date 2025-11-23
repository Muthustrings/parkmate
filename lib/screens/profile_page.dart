import 'package:flutter/material.dart';
import 'package:parkmate/screens/login_page.dart'; // Import LoginPage
// Removed unused import: import 'package:parkmate/utils/color_page.dart';

import 'package:parkmate/screens/settings_page.dart'; // Import SettingsPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Profile',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.surfaceVariant, // Use theme's surfaceVariant color
              child: Icon(
                Icons.person,
                size: 80,
                color: theme.colorScheme.onSurfaceVariant, // Use theme's onSurfaceVariant color
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'User Name', // Replace with actual user name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground, // Use theme's onBackground color
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'user.email@example.com', // Replace with actual user email
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant, // Use theme's onSurfaceVariant color
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings, color: theme.colorScheme.primary),
              title: Text('Settings', style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: theme.colorScheme.primary),
              title: Text('Edit Profile', style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit Profile tapped', style: TextStyle(color: theme.colorScheme.onSurface))),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: theme.colorScheme.primary),
              title: Text('Change Password', style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Change Password tapped', style: TextStyle(color: theme.colorScheme.onSurface))),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.primary),
              title: Text('Logout', style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () {
                // Implement logout functionality here
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false, // This makes sure you can't go back to the profile page
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully!', style: TextStyle(color: theme.colorScheme.onSurface))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
