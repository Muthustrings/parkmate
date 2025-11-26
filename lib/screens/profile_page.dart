import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:parkmate/screens/login_page.dart';
import 'package:parkmate/screens/edit_profile_page.dart';
import 'package:parkmate/screens/change_password_page.dart';
import 'package:parkmate/screens/rate_settings_page.dart';
import 'package:parkmate/providers/theme_provider.dart';
import 'package:parkmate/providers/user_provider.dart';

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
          'Settings',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user?.name ?? 'User Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.phone ?? 'Phone Number',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),

              // Account Settings
              ExpansionTile(
                leading: Icon(
                  Icons.person_outline,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  'Account Settings',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.edit, color: theme.colorScheme.primary),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: theme.colorScheme.primary),
                    title: Text(
                      'Change Password',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Application Settings
              ExpansionTile(
                leading: Icon(
                  Icons.settings_applications,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  'Application Settings',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      );
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      'Notifications',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    value: true, // TODO: Implement state management
                    onChanged: (value) {
                      // TODO: Implement state management
                    },
                  ),
                ],
              ),

              // Checkout Settings
              ExpansionTile(
                leading: Icon(
                  Icons.shopping_cart_checkout,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  'Checkout Settings',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.price_change,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      'Parking Rates',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RateSettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false).clearUser();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Logged out successfully!',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
