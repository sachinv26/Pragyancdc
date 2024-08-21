import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/clients/signup_selection.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/forgot_pass_provider.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  final String phone;
  BuildContext ctx;
  ForgotPassword({required this.ctx, required this.phone, super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Forgot Password'),
      body: Consumer<ForgotPasswordProvider>(
        builder: (context, value, child) {
          return Form(
            key: value.formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.60,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/images/cdc-logo.png'),
                        ),
                      ),
                      kheight30,
                      Text(
                        "Please Enter the Password",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      kheight30,
                      CustomTextFormField(
                        obscureText: _obscureText1,
                        controller: value.newPasswordController,
                        hintText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText1
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText1 = !_obscureText1;
                            });
                          },
                        ),
                        validator: value.validateNewPassword,
                        errorText: value.errText1,
                      ),
                      kheight30,
                      CustomTextFormField(
                        obscureText: _obscureText2,
                        controller: value.confirmPasswordController,
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText2
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                        ),
                        validator: value.validateConfirmPassword,
                        errorText: value.errText2,
                      ),
                      kheight30,
                      Center(
                        child: CustomButton(
                          text: 'Submit',
                          onPressed: () async {
                            if (value.formKey.currentState!.validate()) {
                              final result = await value.forgotPassword(widget.phone);
                              if (result) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                    return const SignupSelection();
                                  }),
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Please fill in all fields correctly.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
