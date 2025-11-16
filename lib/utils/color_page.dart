import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color(0xFF1A73E8); // A common blue for app theme
  static Color secondaryColor = const Color(0xFFFF9800); // Orange for icons

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
      appBar: AppBar(
        title: const Text('Color Utilities'),
      ),
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
