import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/clients/client_login/signup.dart';
import 'package:pragyan_cdc/clients/dashboard/dashboard.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.userId == null) {
      // User is not logged in, navigate to the login page
      return const ClientLogin();
      // return const ClientLogin();
      // return ClientSignUp(
      //   phoneNumber: '98765',
      // );
    } else {
      // User is logged in, navigate to the home page
      return const DashBoard();
    }
  }
}
