import 'package:flutter/material.dart';

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
