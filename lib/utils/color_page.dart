import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1C7CDA); // Updated App Theme Blue
  static const Color accentColor = Color(
    0xFFFF9800,
  ); // A consistent accent color

  // Light theme specific colors
  static const Color lightBackgroundColor = Colors.white;
  static const Color lightTextColor = Colors.black;
  static const Color lightAppBarColor = primaryColor;

  // Dark theme specific colors
  static const Color darkBackgroundColor = Color(
    0xFF121212,
  ); // A dark grey for background
  static const Color darkTextColor = Colors.white;
  static const Color darkAppBarColor = Color(
    0xFF212121,
  ); // A slightly lighter dark grey for app bar
  static const Color darkPrimaryColor = Color(
    0xFF1A439B,
  ); // Original Dark Blue for Dark Mode

  // This class is not meant to be instantiated, so a private constructor is appropriate.
  AppColors._();
}

// The ColorPage StatelessWidget seems to be for demonstration purposes.
// I will keep it as is, but it's not directly used by HomePage.
class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Utilities')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColorBox(Colors.red, 'Red'),
            _buildColorBox(Colors.blue, 'Blue'),
            _buildColorBox(Colors.green, 'Green'),
            _buildColorBox(Colors.yellow, 'Yellow'),
            _buildColorBox(Colors.purple, 'Purple'),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 50,
        color: color,
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
