import 'package:flutter/material.dart';
import 'package:pragyan_cdc/view/client_login/get_otp.dart';
import 'package:pragyan_cdc/view/client_login/login.dart';
import 'package:pragyan_cdc/view/client_login/signup.dart';
import 'package:pragyan_cdc/view/client_login/signup2.dart';
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
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green),
      title: 'Pragyan',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/introduction': (context) => const OnBoardingScreen(),
        '/signupSelection': (context) => const SignupSelection(),
        '/clientLogin': (context) => const ClientLogin(),
        '/clientSignup': (context) => const ClientSignUp(),
        '/clientSignupSecond': (context) => const SignupSecond(),
        '/getOtp': (context) => const GetOtp(),
      },
    );
  }
}
