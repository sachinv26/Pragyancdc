import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
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
  bool _isLoading = false;
  bool _obscureText = true;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Login'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.78,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset('assets/images/cdc-logo.png'),
                    ),
                  ),
                  const Text('Login to access your account', style: kTextStyle1),
                  CustomTextFormField(
                    controller: _mobileController,
                    hintText: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    iconData: const Icon(Icons.phone),
                  ),
                  CustomTextFormField(
                    obscureText: _obscureText,
                    hintText: 'Password',
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
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
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Login',
                    isLoading: _isLoading,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final String mobile = _mobileController.text;
                        final String password = _passwordController.text;
                        final String encodedPassword = base64.encode(utf8.encode(password));
                        final response = await ApiServices().parentLogin(mobile, encodedPassword);

                        if (response['status'] == 1) {
                          final String authToken = response['prag_parent_auth_token'];
                          final String userId = response['profile']['parent_user_id'];

                          AuthProvider authProvider = Provider.of<AuthProvider>(widget.ctx, listen: false);
                          await authProvider.login(authToken, userId);

                          final userProfile = UserProfile.fromJson(response['profile']);
                          Provider.of<UserProvider>(widget.ctx, listen: false).setUserProfile(userProfile);
                        } else if (response['status'] == -1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PhoneNumberVerification(
                              ctx: context,
                              otpFor: '3',
                              userid: response['parent_user_id'],
                            )),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: response['message'],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
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
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
