import 'package:flutter/material.dart';
import 'package:parkmate/utils/color_page.dart'; // Assuming color_page.dart exists for colors
import 'package:parkmate/screens/check_in_page.dart';
import 'package:parkmate/screens/history_page.dart';
import 'package:parkmate/screens/profile_page.dart'; // Import ProfilePage

import 'package:parkmate/screens/check_out_page.dart'; // Import CheckOutPage
import 'package:parkmate/screens/reports_page.dart'; // Import ReportsPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle({required int index}) {
    switch (index) {
      case 0:
        return 'Parking Lot A'; // Default for home
      case 1:
        return 'Settings';
      default:
        return 'ParkMate';
    }
  }

  Widget _buildFeatureCard({
    required BuildContext context, // Add BuildContext here
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50.0, color: color),
            const SizedBox(height: 10.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface, // Make text color theme-aware
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Move theme declaration here
    final List<Widget> _widgetOptions = <Widget>[
      // Original Home content (GridView of cards)
      Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            color: theme.colorScheme.surface, // Use theme's surface color
            child: Column(
              children: [
                Text(
                  'ParkMate',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors
                        .primaryColor, // Use a consistent primary color
                  ),
                ),
                Text(
                  'Digital Parking System',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        AppColors.accentColor, // Use a consistent accent color
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color:
                  theme.colorScheme.background, // Use theme's background color
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildFeatureCard(
                    context: context, // Pass context
                    icon: Icons.directions_car,
                    label: 'Check-In',
                    color: theme
                        .colorScheme
                        .secondary, // Use theme's secondary color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckInPage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context: context, // Pass context
                    icon: Icons.receipt_long,
                    label: 'Check Out',
                    color:
                        theme.colorScheme.primary, // Use theme's primary color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckOutPage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context: context, // Pass context
                    icon: Icons.history,
                    label: 'History',
                    color: theme
                        .colorScheme
                        .secondary, // Use theme's secondary color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context: context, // Pass context
                    icon: Icons.analytics,
                    label: 'Reports',
                    color:
                        theme.colorScheme.primary, // Use theme's primary color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const ProfilePage(), // Profile Page
    ];

    return Scaffold(
      appBar:
          _selectedIndex ==
              1 // If Profile page is selected
          ? null // No AppBar for Profile page to avoid double heading
          : AppBar(
              backgroundColor:
                  theme.colorScheme.primary, // Use theme's primary color
              title: Text(
                _getAppBarTitle(index: _selectedIndex),
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                ), // Use theme's onPrimary color
              ),
              actions: [], // Removed the profile icon
            ),
      body: _widgetOptions.elementAt(
        _selectedIndex,
      ), // Add this line to display the selected page content
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme
            .colorScheme
            .surface, // Use theme's surface color for background
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: _selectedIndex == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
      ),
    );
  }
}
