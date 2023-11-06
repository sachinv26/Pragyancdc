import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  bool hasSeenIntroduction = false;

  @override
  void initState() {
    super.initState();

    // Using an async function to wait for SharedPreferences instance
    _checkIntroduction();
  }

  Future<void> _checkIntroduction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user has seen the introduction pages before.
    hasSeenIntroduction = prefs.getBool('hasSeenIntroduction') ?? false;

    // Start a timer to update the loader progress.
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.1;
        if (_progress >= 1.0) {
          // If the loader progress has reached 100%, navigate to the next step.
          // Cancel the timer when progress reaches 1.0
          timer.cancel();
          if (hasSeenIntroduction) {
            // If the user has seen the introduction pages before, navigate to the home page.
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // If the user has not seen the introduction pages before, navigate to the introduction screens.
            Navigator.pushReplacementNamed(context, '/introduction');
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 35,
              ),
              Image.asset(
                'assets/images/Pragyan_Logo.png',
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              // Loader

              Container(
                alignment: Alignment.bottomCenter,
                width: SizeConfig.screenWidth, // Adjust the width as needed
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white,
                  color: Colors.green,
                ),
              ),

              // Text
            ],
          ),
        ),
      ),
    );
  }
}
