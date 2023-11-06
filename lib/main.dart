import 'package:flutter/material.dart';
import 'package:pragyan_cdc/view/signup_selection.dart';
import 'package:pragyan_cdc/view/intro/intro_outline.dart';
import 'package:pragyan_cdc/view/splash.dart';

void main() {
  runApp(const Pragyan());
}

class Pragyan extends StatelessWidget {
  const Pragyan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      title: 'Pragyan',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/introduction': (context) => const OnBoardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
