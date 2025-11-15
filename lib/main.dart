import 'package:flutter/material.dart';
import 'package:parkmate/utils/color_page.dart';
import 'package:parkmate/login_page.dart'; // Import for LoginPage
import 'dart:async'; // Import for Timer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A439B)), // Use the blue color
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Set SplashScreen as the home page
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A439B), // Blue background color
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
            const Text(
              'ParkMate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Digital Parking System',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
