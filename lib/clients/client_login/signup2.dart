import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
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

  @override
  Widget build(BuildContext context) {
    var signUpDataProvider = Provider.of<SignUpDataProvider>(context);
    return Scaffold(
      appBar: customAppBar(
        title: 'Create Password'
      ),
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
                  const Text('Create a password',style: kTextStyle1,),
                  CustomTextFormField(
                    hintText: 'Create Password',
                    controller: signUpDataProvider.passwordController,
                    obscureText: true,
                    iconData: const Icon(Icons.visibility_off),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: _confirmPass,
                      onSaved: (newValue) {
                        if (signUpDataProvider.passwordController != newValue) {
                          setState(() {
                            confirmPasswordError = 'Password do not match';
                          });
                        }
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
                  Text(
                    confirmPasswordError,
                    style: const TextStyle(color: Colors.red),
                  ),
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
                            final response =
                                await ApiServices().parentSignup(jsonData);
                            if (response['status'] == 1) {
                              //successfully created account
                              //navigate to login page

                              Fluttertoast.showToast(
                                msg: 'Account created succesfully!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              //error
                              Fluttertoast.showToast(
                                msg: response['message'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          }
                          // Make API call using fullSignUpModel
                        }),
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
  
