import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/signup_selection.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/forgot_pass_provider.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final String phone;
  BuildContext ctx;
  ForgotPassword({required this.ctx, required this.phone, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Forgot Password'),
      body: Consumer<ForgotPasswordProvider>(
        builder: (context, value, child) {
          return Form(
            key: value.formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      phone,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    kheight10,
                    CustomTextFormField(
                      obscureText: true,
                      controller: value.newPasswordController,
                      hintText: 'New Password',
                      validator: (p0) {
                        value.validateNewPassword(p0);
                        return null;
                      },
                    ),
                    Text(
                      value.errText1,
                      style: kErrorTextStyle,
                    ),
                    kheight10,
                    CustomTextFormField(
                      obscureText: true,
                      controller: value.confirmPasswordController,
                      hintText: 'Confirm Password',
                      validator: (p0) {
                        value.validateConfirmPassword(p0);
                        return null;
                      },
                    ),
                    Text(
                      value.errText2,
                      style: kErrorTextStyle,
                    ),
                    kheight30,
                    ElevatedButton(
                        onPressed: () async {
                          final result = await value.forgotPassword(phone);
                          if (true) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const SignupSelection();
                            }));
                          }

                          //   Navigator.popUntil(context,
                          //       ModalRoute.withName('/clientLogin/:ctx'));
                        },
                        child: const Text('Submit'))
                  ]),
            ),
          );
        },
      ),
    );
  }
}
