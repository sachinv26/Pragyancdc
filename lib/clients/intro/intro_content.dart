import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final String imagePath;
  final String text1;
  final String text2;
  final bool showSkipButton;
  final VoidCallback? onSkipPressed;
  final PageController? controller; // New property to accept the PageController

  const IntroPage({
    required this.imagePath,
    required this.text1,
    required this.text2,
    this.showSkipButton = false,
    this.onSkipPressed,
    this.controller, // Pass the PageController
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (showSkipButton)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    if (controller != null) {
                      // Use the provided PageController to jump to the last page
                      controller!.jumpToPage(2);
                    }
                    if (onSkipPressed != null) {
                      // Call the optional onSkipPressed callback
                      onSkipPressed!();
                    }
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 90),
          Image.asset(imagePath),
          const SizedBox(height: 40),
          Text(
            text1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            text2,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
