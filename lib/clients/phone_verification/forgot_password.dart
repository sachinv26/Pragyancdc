import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/forgot_pass_provider.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final String phone;
  const ForgotPassword({required this.phone, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Forgot Password'),
      body: Consumer<ForgotPasswordProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Text(
                phone,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              kheight10,
              CustomTextFormField(
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
              ElevatedButton(onPressed: () {}, child: const Text('Submit'))
            ]),
          );
        },
      ),
    );
  }
}
