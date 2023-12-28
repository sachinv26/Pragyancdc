import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/provider/password_change.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  final BuildContext ctx;
  const ChangePasswordScreen({required this.ctx, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
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
                          await Provider.of<AuthProvider>(ctx, listen: false)
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


// class ChangePasswordScreen extends StatelessWidget {
//   ChangePasswordScreen({super.key});
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(title: 'Change Password'),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Consumer<PasswordChangeModel>(
//           builder: (context, model, child) {
//             return Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomTextFormField(
//                     hintText: 'Create Password',
//                     controller: model.oldPasswordController,
//                     obscureText: true,
//                     iconData: const Icon(Icons.visibility_off),
//                   ),
//                   kheight30,
//                   CustomTextFormField(
//                     hintText: 'New Password',
//                     controller: model.newPasswordController,
//                     obscureText: true,
//                     validator: (p0) {
//                       if (p0!.isEmpty) {
//                         model.setErrmsg1('Password cannot be empty');
//                         return 'Password cannot be empty'; // Return the error message
//                       } else if (p0.length < 6) {
//                         model.setErrmsg1(
//                             'Password must be at least 6 characters long');
//                         return 'Password must be at least 6 characters long'; // Return the error message
//                       }
//                       return null; // Return null when there's no error
//                     },
//                     iconData: const Icon(Icons.visibility_off),
//                   ),
//                   Text(
//                     model.errText1,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                   kheight30,
//                   CustomTextFormField(
//                     hintText: 'Confirm new password',
//                     controller: model.confirmNewPasswordController,
//                     obscureText: true,
//                     iconData: const Icon(Icons.visibility_off),
//                   ),
//                   kheight30,
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         debugPrint('validated successfully');
//                       }
//                       //   model.changePassword();
//                       // TODO: Call your API if needed
//                     },
//                     child: const Text('Change Password'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
