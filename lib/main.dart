import 'package:flutter/material.dart';
import 'package:parkmate/screens/login_page.dart'; // Import for LoginPage
import 'dart:async'; // Import for Timer
import 'package:provider/provider.dart'; // Import provider
import 'package:parkmate/providers/theme_provider.dart'; // Import ThemeProvider
import 'package:parkmate/providers/parking_provider.dart'; // Import ParkingProvider
import 'package:parkmate/providers/parking_rate_provider.dart'; // Import ParkingRateProvider
import 'package:parkmate/utils/color_page.dart'; // Import AppColors for custom colors

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ParkingProvider()),
        ChangeNotifierProvider(create: (context) => ParkingRateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ParkMate',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(
                  seedColor: AppColors.primaryColor,
                  brightness: Brightness.light,
                ).copyWith(
                  background: AppColors.lightBackgroundColor,
                  onBackground: AppColors.lightTextColor,
                  surface: AppColors.lightBackgroundColor,
                  onSurface: AppColors.lightTextColor,
                  onSurfaceVariant: AppColors.lightTextColor.withOpacity(
                    0.6,
                  ), // Ensure visibility for hints/icons
                  primary: AppColors.lightAppBarColor,
                  onPrimary: AppColors.lightTextColor,
                ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightAppBarColor,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor:
                  AppColors.primaryColor, // Dark blue background for snackbar
              contentTextStyle: TextStyle(
                color: AppColors.darkTextColor,
              ), // White text for snackbar content
            ),
          ),
          darkTheme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(
                  seedColor: AppColors.primaryColor,
                  brightness: Brightness.dark,
                ).copyWith(
                  background: AppColors.darkBackgroundColor,
                  onBackground: AppColors.darkTextColor,
                  surface: const Color(
                    0xFF1E1E1E,
                  ), // Slightly lighter dark grey for surfaces
                  onSurface: AppColors.darkTextColor,
                  onSurfaceVariant: AppColors.darkTextColor.withOpacity(
                    0.7,
                  ), // Slightly more opaque for better visibility
                  primary: AppColors.primaryColor,
                  onPrimary: AppColors.darkTextColor,
                  secondary: AppColors
                      .primaryColor, // Set secondary color to primary for dark mode
                ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryColor,
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor:
                  AppColors.primaryColor, // Dark blue background for snackbar
              contentTextStyle: TextStyle(
                color: AppColors.darkTextColor,
              ), // White text for snackbar content
            ),
          ),
          home: const SplashScreen(), // Set SplashScreen as the home page
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary, // Use theme's primary color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/Logo.png',
              width: 150, // Adjust size as needed
              height: 150, // Adjust size as needed
            ),
            const SizedBox(height: 20),
            Text(
              'ParkMate',
              style: TextStyle(
                color:
                    theme.colorScheme.onPrimary, // Use theme's onPrimary color
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Digital Parking System',
              style: TextStyle(
                color:
                    theme.colorScheme.onPrimary, // Use theme's onPrimary color
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
