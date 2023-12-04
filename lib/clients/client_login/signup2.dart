import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/full_signup_model.dart';
import 'package:pragyan_cdc/model/temp_signup_model.dart';

import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:provider/provider.dart';

class SignupSecond extends StatelessWidget {
  final TempModel tempModel;

  const SignupSecond({required this.tempModel, super.key});

  @override
  Widget build(BuildContext context) {
    var signUpDataProvider = Provider.of<SignUpDataProvider>(context);
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome Back!',
                  style: kTextStyle2,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 48, 103, 50)),
                ),
                const Text('Create your account to get started.'),
                CustomTextFormField(
                  hintText: 'Create Password',
                  controller: signUpDataProvider.passwordController,
                  obscureText: true,
                  iconData: const Icon(Icons.visibility_off),
                ),
                // const CustomTextFormField(
                //   hintText: 'Confirm Password',

                //   obscureText: true,
                // ),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  hintText: 'Mobile Number',
                  controller: signUpDataProvider.phoneNumberController,
                  iconData: const Icon(Icons.phone),
                ),
                kheight60,
                Center(
                  child: CustomButton(
                      text: 'Create Account',
                      onPressed: () {
                        // String password = passwordController.text;
                        // String phoneNumber = phoneNumberController.text;

                        // Combine data into FullSignUpModel
                        FullSignUpModel fullSignUpModel = FullSignUpModel(
                          parentName:
                              signUpDataProvider.parentNameController.text,
                          childName:
                              signUpDataProvider.childNameController.text,
                          childDOB: signUpDataProvider.childDOBController.text,
                          email: signUpDataProvider.mailIdController.text,
                          location: signUpDataProvider.locationController.text,
                          address: signUpDataProvider.addressController.text,
                          password: signUpDataProvider.passwordController.text,
                          phoneNumber:
                              signUpDataProvider.phoneNumberController.text,
                        );

                        // Set the combined model to the provider
                        Provider.of<SignUpDataProvider>(context, listen: false)
                            .submitForm();
                        //create account api
                        print('account created');
                        print(fullSignUpModel);
                      }
                      // Make API call using fullSignUpModel

                      ),
                )
                // Center(
                //     child: CustomButton(
                //         text: 'Verify',
                //         onPressed: () {
                //           Navigator.pushNamed(context, '/getOtp');
                //         })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
