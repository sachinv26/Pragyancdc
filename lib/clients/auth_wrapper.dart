import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/clients/dashboard/dashboard.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        debugPrint('Authwrapper context: $context');
        debugPrint('AuthWrapper rebuild: isLoggedIn=${authProvider.isLoggedIn}');
        if (authProvider.isCheckingLogin) {
          return Center(child: Loading());
        } else if (authProvider.isLoggedIn) {
          return DashBoard(ctx: context);
        } else {
          return ClientLogin(ctx: context,);
        }
      },
    );
  }
}
