import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/full_signup_model.dart';
import 'package:pragyan_cdc/provider/temp_user_model.dart';
import 'package:provider/provider.dart';

class SignupSecond extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  SignupSecond({super.key});

  @override
  Widget build(BuildContext context) {
    var tempModelProvider = Provider.of<TempModelProvider>(context);
    var tempModel = tempModelProvider.tempModel;

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
                  controller: passwordController,
                  obscureText: true,
                  iconData: const Icon(Icons.visibility_off),
                ),
                // const CustomTextFormField(
                //   hintText: 'Confirm Password',

                //   obscureText: true,
                // ),
                CustomTextFormField(
                  hintText: 'Mobile Number',
                  controller: phoneNumberController,
                  iconData: const Icon(Icons.phone),
                ),
                kheight60,
                Center(
                  child: CustomButton(
                    text: 'Create Account',
                    onPressed: () {
                      if (tempModel != null) {
                        String password = passwordController.text;
                        String phoneNumber = phoneNumberController.text;

                        // Combine data into FullSignUpModel
                        FullSignUpModel fullSignUpModel = FullSignUpModel(
                          parentName: tempModel.parentName,
                          childName: tempModel.childName,
                          childDOB: tempModel.childDOB,
                          email: tempModel.mailId,
                          location: tempModel.location,
                          address: tempModel.address,
                          password: password,
                          phoneNumber: phoneNumber,
                        );

                        // Set the combined model to the provider
                        Provider.of<TempModelProvider>(context, listen: false)
                            .setFullSignUpModel(fullSignUpModel);
                        //create account api
                        print('account created');
                        print(tempModel);
                      }
                      // Make API call using fullSignUpModel
                    },
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
