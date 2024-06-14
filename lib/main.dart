import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/clients/dashboard/child/add_child.dart';
import 'package:pragyan_cdc/clients/dashboard/dashboard.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/therapy_appointment_summary.dart';
import 'package:pragyan_cdc/clients/signup_selection.dart';
import 'package:pragyan_cdc/clients/intro/intro_outline.dart';
import 'package:pragyan_cdc/clients/splash.dart';
import 'package:pragyan_cdc/constants/size_config.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/provider/branch_provider.dart';
import 'package:pragyan_cdc/provider/child_image_provider.dart';
import 'package:pragyan_cdc/provider/forgot_pass_provider.dart';
import 'package:pragyan_cdc/provider/change_pass_provider.dart';
import 'package:pragyan_cdc/provider/phone_verification_provider.dart';
import 'package:pragyan_cdc/provider/user_provider.dart';
import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:pragyan_cdc/therapists/view/dashboard.dart';
import 'package:provider/provider.dart';
import 'dart:io';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => SignUpDataProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ChildImageProvider()),
    ChangeNotifierProvider(create: (context) => PhoneVerificationProvider()),
    ChangeNotifierProvider(create: (context) => ChangePasswordProvider()),
    ChangeNotifierProvider(create: (context) => ForgotPasswordProvider()),
    ChangeNotifierProvider(create: (context) => LocationProvider()),
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade600),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green),
      title: 'Pragyan',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/introduction': (context) => const OnBoardingScreen(),
        '/signupSelection': (context) => const SignupSelection(),
        '/clientLogin/:context': (context) => ClientLogin(
            ctx: ModalRoute.of(context)?.settings.arguments as BuildContext
        ),
        '/dashboard/:context': (context) => DashBoard(
          // ctx: ModalRoute.of(context)?.settings.arguments as BuildContext
        ),
        '/addChildScreen': (context) => const AddChildScreen(),
        '/therapistDashboard': (context) => TherapistDashBoard(),
        '/dashboard': (context) => DashBoard(),
      },
    );
  }
}
