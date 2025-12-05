import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/providers/theme_provider.dart'; // Assuming this will be created

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
        ),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            value: true, // TODO: Implement state management for notifications
            onChanged: (value) {
              // TODO: Implement state management for notifications
            },
          ),

          // Other settings options can be added here
        ],
      ),
    );
  }
}
