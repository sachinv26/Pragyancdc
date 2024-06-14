import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/provider/change_pass_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  // final BuildContext ctx;
  const ChangePasswordScreen({ super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Change Password'
      ),
      body: Consumer<ChangePasswordProvider>(
        builder: (context, provider, child) => Form(
          key: provider.formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Use your CustomTextFormField for the password fields
                CustomTextFormField(
                  controller: provider.currentPasswordController,
                  hintText: 'Current Password',
                  obscureText: true,
                  //validator: provider.validateCurrentPassword,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: provider.newPasswordController,
                  hintText: 'New Password',
                  obscureText: true,
                  validator: provider.validateNewPassword,
                ),
                Text(
                  provider.errText1,
                  style: kErrorTextStyle,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: provider.confirmPasswordController,
                  hintText: 'Confirm New Password',
                  obscureText: true,
                  validator: provider.validateConfirmPassword,
                ),
                Text(
                  provider.errText2,
                  style: kErrorTextStyle,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          await provider.changePassword();
                          Future.delayed(const Duration(seconds: 3));
                          await Provider.of<AuthProvider>(context, listen: false)
                              .logout();

                          if (context.mounted) {
                            Navigator.popUntil(context,
                                ModalRoute.withName('/signupSelection'));
                          }
                        },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


