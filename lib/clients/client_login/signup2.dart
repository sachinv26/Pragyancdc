import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/full_signup_model.dart';
import 'package:pragyan_cdc/model/temp_signup_model.dart';

import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:provider/provider.dart';

class SignupSecond extends StatefulWidget {
  final TempModel tempModel;

  const SignupSecond({required this.tempModel, super.key});

  @override
  State<SignupSecond> createState() => _SignupSecondState();
}

class _SignupSecondState extends State<SignupSecond> {
  String confirmPasswordError = '';
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _confirmPass = TextEditingController();

  // late FToast fToast;

  // @override
  // void initState() {
  //   super.initState();
  //   fToast = FToast();
  //   // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
  //   fToast.init(context);
  // }

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
            child: Form(
              key: _form,
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
                  const Text('Create a password.'),
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
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: _confirmPass,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password again";
                        }
                        if (value != signUpDataProvider.passwordController) {
                          return 'Password do not match';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Re-enter password',
                          hintStyle: khintTextStyle,
                          // Change the color as needed

                          border: InputBorder.none,
                          constraints: BoxConstraints(
                              maxHeight: 55, maxWidth: double.infinity)),
                    ),
                  ),
                  // Text(
                  //   confirmPasswordError,
                  //   style: const TextStyle(color: Colors.red),
                  // ),
                  // CustomTextFormField(
                  //   keyboardType: TextInputType.phone,
                  //   hintText: 'Mobile Number',
                  //   controller: signUpDataProvider.phoneNumberController,
                  //   iconData: const Icon(Icons.phone),
                  // ),
                  kheight60,
                  Center(
                    child: CustomButton(
                        text: 'Create Account',
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            String encodedPass = base64.encode(utf8.encode(
                                signUpDataProvider.passwordController.text));
                            // Combine data into FullSignUpModel
                            FullSignUpModel fullSignUpModel = FullSignUpModel(
                                parentName: signUpDataProvider
                                    .parentNameController.text,
                                childName:
                                    signUpDataProvider.childNameController.text,
                                childDOB: signUpDataProvider.childDOB,
                                email: signUpDataProvider.mailIdController.text,
                                location: widget.tempModel.location,
                                gender: widget.tempModel.gender,
                                address:
                                    signUpDataProvider.addressController.text,
                                password: encodedPass,
                                phoneNumber: widget.tempModel.mobileNumber

                                //imagePath: signUpDataProvider.imagePath
                                );

                            Map<String, dynamic> jsonData =
                                fullSignUpModel.toJson();
                            print('Before calling api:');
                            print(jsonData);
                          }
                          // Make API call using fullSignUpModel
                        }),
                  ),
                ],
              ),
            ),
          ),

          // Center(
          //     child: CustomButton(
          //         text: 'Verify',
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/getOtp');
          //         })),
        ),
      ),
    );
  }

  Future<void> checkAndRequestPermissions() async {
    // Check if the permission is already granted
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      // Permission is already granted, proceed with file access
      print('Permission already granted');
      return;
    } else {
      // Request permission
      PermissionStatus result = await Permission.storage.request();

      if (result.isGranted) {
        // Permission granted, proceed with file access
        print('Permission granted');
      } else {
        // Permission denied, handle accordingly
        print('Permission denied');
      }
    }
    //   void showToast() => Fluttertoast.showToast(
    //       msg: 'User Created Successfully',
    //       fontSize: 18,
    //       gravity: ToastGravity.CENTER);
    // }

    // Widget buildToast() {
    //   return Container(
    //       padding: const EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           color: Colors.green, borderRadius: BorderRadius.circular(25)),
    //       child: const Text('User Created successfully'));
  }
}
