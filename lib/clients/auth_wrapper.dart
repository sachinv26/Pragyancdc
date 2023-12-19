import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/clients/dashboard/dashboard.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check the login status
        authProvider.checkLoginStatus();

        // Return the appropriate screen based on the login status
        if (authProvider.isLoggedIn) {
          return DashBoard();
        } else {
          return ClientLogin();
        }
      },
    );
  }
}
