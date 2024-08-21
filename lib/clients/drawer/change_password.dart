import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/provider/change_pass_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Change Password'),
      body: Consumer<ChangePasswordProvider>(
        builder: (context, provider, child) => Form(
          key: provider.formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: provider.currentPasswordController,
                  hintText: 'Current Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: provider.newPasswordController,
                  hintText: 'New Password',
                  obscureText: true,
                  validator: provider.validateNewPassword,
                ),
                if (provider.errText1.isNotEmpty)
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
                if (provider.errText2.isNotEmpty)
                  Text(
                    provider.errText2,
                    style: kErrorTextStyle,
                  ),
                const SizedBox(height: 20),
                CustomButton(text: 'Change Password',
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                    print('Change password button pressed');
                    await provider.changePassword();
                    print('Password change completed');
                    Future.delayed(const Duration(seconds: 3));
                    await Provider.of<AuthProvider>(context, listen: false)
                        .logout();
                    print('Logged out');
                    if (context.mounted) {
                      Navigator.popUntil(context,
                          ModalRoute.withName('/signupSelection'));
                      print('Navigated to /signupSelection');
                    }
                  },
                ),
                // ElevatedButton(
                //   onPressed: provider.isLoading
                //       ? null
                //       : () async {
                //     print('Change password button pressed');
                //     await provider.changePassword();
                //     print('Password change completed');
                //     Future.delayed(const Duration(seconds: 3));
                //     await Provider.of<AuthProvider>(context, listen: false)
                //         .logout();
                //     print('Logged out');
                //     if (context.mounted) {
                //       Navigator.popUntil(context,
                //           ModalRoute.withName('/signupSelection'));
                //       print('Navigated to /signupSelection');
                //     }
                //   },
                //   child: const Text('Change Password'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
