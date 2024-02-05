import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool isLoading; // Add this property

  const CustomButton({
    Key? key, // Add this line
    required this.text,
    this.onPressed,
    this.width = 170,
    this.height = 40,
    this.isLoading = false, // Add this line
  }) : super(key: key); // Add this line

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Background color (constant)
        minimumSize: Size(width, height), // Width and height of the button
      ),
      child: isLoading
          ? CircularProgressIndicator() // Show CircularProgressIndicator when isLoading is true
          : Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }
}
