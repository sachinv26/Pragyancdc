import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final String imagePath;
  final String text1;
  final String text2;
  const IntroPage(
      {required this.imagePath,
      required this.text1,
      required this.text2,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.green,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 90,
        ),
        Image.asset(imagePath),
        const SizedBox(
          height: 40,
        ),
        Text(
          text1,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          text2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
}
