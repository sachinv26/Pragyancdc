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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return PhoneNumberVerification(
                                  ctx: widget.ctx,
                                  otpFor: '2',
                                );
                              },
                            ));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue),
                          )),
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
                            final String authToken =
                                response['prag_parent_auth_token'];
                            final String userId =
                                response['profile']['parent_user_id'];

                            AuthProvider authProvider =
                                Provider.of<AuthProvider>(widget.ctx,
                                    listen: false);
                            // Save user credentials to FlutterSecureStorage
                            await authProvider.login(authToken, userId);

                            debugPrint(' auth provider login');
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
                                return PhoneNumberVerification(
                                  ctx: widget.ctx,
                                  otpFor: '1',
                                );
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
