import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/providers/theme_provider.dart'; // Assuming this will be created
import 'package:parkmate/screens/rate_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          ListTile(
            leading: Icon(
              Icons.attach_money,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Parking Rates',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
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
          // Other settings options can be added here
        ],
      ),
    );
  }
}
