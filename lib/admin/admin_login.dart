import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/dashboard/dashboard_admin.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMobile = prefs.getString('mobile');
    String? savedPassword = prefs.getString('password');

    if (savedMobile != null && savedPassword != null) {
      _mobileController.text = savedMobile;
      _passwordController.text = savedPassword;

      // You can now proceed with authentication if needed.
      _login();
    }
  }

  void _login() {
    // print(_mobileController.text);
    // print(_passwordController.text);
    // Check if the entered username and password match the dummy values.
    if (_mobileController.text == 'admin' &&
        _passwordController.text == 'admin123') {
      // Save credentials if login is successful.
      _saveCredentials(_mobileController.text, _passwordController.text);

      // Navigate to the HomeScreen.
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return const AdminDashboard();
        },
      ));
    } else {
      // Handle incorrect credentials (e.g., show an error message).
      print('Invalid credentials');
    }
  }

  void _saveCredentials(String mobile, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', mobile);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.78),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Admin Login',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const Text('Login to access your admin account.'),
                    CustomTextFormField(
                      controller: _mobileController,
                      hintText: 'Username',
                      //  keyboardType: TextInputType.phone,
                      iconData: const Icon(Icons.phone),
                    ),
                    CustomTextFormField(
                      obscureText: true,
                      hintText: 'Password',
                      controller: _passwordController,
                      iconData: IconButton(
                        icon: const Icon(Icons.visibility_off),
                        onPressed: () {
                          PasswordToggle(
                            controller: _passwordController,
                          );
                        },
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password',
                        style: kTextStyle1,
                      ),
                    ),
                    CustomButton(
                        text: 'Login',
                        onPressed: () {
                          _login();
                        }),
                  ],
                ),
              ),
            ),
          ),
        )
        //assets\images\2 94701.png
        );
  }
}
