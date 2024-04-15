import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
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
    this.isLoading = false,  // Add this line
  }) : super(key: key);
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
 // Add this line
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.zero, // Remove padding
        minimumSize: Size(widget.width, widget.height), // Width and height of the button
        elevation: 0, // Remove elevation// Set primary color to transparent
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade500],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          child: widget.isLoading
              ? CircularProgressIndicator() // Show CircularProgressIndicator when isLoading is true
              : Text(
            widget.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
