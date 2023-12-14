import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/get_otp.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/clients/dashboard/dashboard.dart';
import 'package:pragyan_cdc/clients/signup_selection.dart';
import 'package:pragyan_cdc/clients/intro/intro_outline.dart';
import 'package:pragyan_cdc/clients/splash.dart';
import 'package:pragyan_cdc/constants/size_config.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';

import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => SignUpDataProvider()),
  ], child: const Pragyan()));
}

class Pragyan extends StatelessWidget {
  const Pragyan({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontSize: 1.7 * SizeConfig.textMultiplier,
            ),
            bodySmall: TextStyle(
              fontSize: 1.7 * SizeConfig.textMultiplier,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green),
      title: 'Pragyan',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/introduction': (context) => const OnBoardingScreen(),
        '/signupSelection': (context) => const SignupSelection(),
        '/clientLogin': (context) => const ClientLogin(),
        '/getOtp': (context) => const GetOtp(),
        '/dashBoard': (context) => const DashBoard(),
      },
    );
  }
}
