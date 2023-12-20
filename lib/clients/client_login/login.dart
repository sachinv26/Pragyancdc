import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/api/user_api/user_api.dart';
import 'package:pragyan_cdc/clients/phone_verification/phone.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ClientLogin extends StatefulWidget {
  BuildContext ctx;
  ClientLogin({required this.ctx, super.key});

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {
  final UserAPI userAPI = UserAPI();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _checkIfLoggedIn();
  // }

  // void _checkIfLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedMobile = prefs.getString('mobile');
  //   String? savedPassword = prefs.getString('password');

  //   if (savedMobile != null && savedPassword != null) {
  //     _mobileController.text = savedMobile;
  //     _passwordController.text = savedPassword;

  //     // You can now proceed with authentication if needed.
  //     _login();
  //   }
  // }

  // void _login() async {
  //   // Implement your authentication logic here.
  //   // Once authenticated, you can save the credentials.
  //   String mobile = _mobileController.text;
  //   String password = _passwordController.text;

  //   await UserAPI().authenticateUser(mobile, password);

  //   // Add the navigation logic here.
  // }

  // void _saveCredentials(String mobile, String password) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mobile', mobile);
  //   await prefs.setString('password', password);
  // }

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
                    Image.asset(
                      'assets/images/2 94701.png',
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const Text('Login to access your account.'),
                    CustomTextFormField(
                      controller: _mobileController,
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
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
                        onPressed: () async {
                          print('got inside login button');
                          final String mobile = _mobileController.text;
                          final String password = _passwordController.text;
                          final String encodedPassword =
                              base64.encode(utf8.encode(password));
                          final response = await ApiServices()
                              .parentLogin(mobile, encodedPassword);
                          if (response['status'] == 1) {
                            print('api call done and status returned 1');
                            //success
                            // ApiServices()
                            //     .setToken(response['prag_parent_auth_token']);
                            // final storage = new FlutterSecureStorage();
                            // await storage.write(
                            //     key: 'authToken',
                            //     value: response['prag_parent_auth_token']);
// Parse the user profile data
                            AuthProvider authProvider =
                                Provider.of<AuthProvider>(widget.ctx,
                                    listen: false);
                            await authProvider
                                .login(response['prag_parent_auth_token']);

                            print(' auth provider login');
                            final userProfile =
                                UserProfile.fromJson(response['profile']);
                            // Set the user profile in the provider
                            Provider.of<UserProvider>(widget.ctx, listen: false)
                                .setUserProfile(userProfile);
                            //  Navigator.pushNamed(context, '/dashboard/$ctx');
                          } else {
                            //error
                            Fluttertoast.showToast(
                              msg: response['message'],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New User? ', style: kTextStyle1),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const PhoneNumberVerification();
                              },
                            ));
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    )
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

class PasswordToggle extends StatefulWidget {
  final TextEditingController controller;

  const PasswordToggle({super.key, required this.controller});

  @override
  _PasswordToggleState createState() => _PasswordToggleState();
}

class _PasswordToggleState extends State<PasswordToggle> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      controller: widget.controller, // Pass the controller here.
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }
}
