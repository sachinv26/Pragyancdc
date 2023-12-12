import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pragyan_cdc/api/user_api/user_api.dart';
import 'package:pragyan_cdc/clients/client_login/get_otp.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
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
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            // Combine data into FullSignUpModel
                            FullSignUpModel fullSignUpModel = FullSignUpModel(
                              parentName:
                                  signUpDataProvider.parentNameController.text,
                              childName:
                                  signUpDataProvider.childNameController.text,
                              childDOB: signUpDataProvider.childDOB,
                              email: signUpDataProvider.mailIdController.text,
                              location:
                                  signUpDataProvider.locationController.text,
                              address:
                                  signUpDataProvider.addressController.text,
                              password:
                                  signUpDataProvider.passwordController.text,
                              phoneNumber:
                                  signUpDataProvider.phoneNumberController.text,
                              //imagePath: signUpDataProvider.imagePath
                            );

                            Map<String, dynamic> jsonData =
                                fullSignUpModel.toJson();
                            print('Before calling api:');
                            print(jsonData);
                            //    await checkAndRequestPermissions();

                            final response = await UserAPI.registerUser(jsonData
                                // signUpDataProvider.file,
                                //signUpDataProvider.imagePath
                                );
                            // var map = response.body as Map;
                            // debugPrint('returned response');
                            // print(map);
                            // if (map['status'] == 200) {
                            //   Navigator.of(context).pop();
                            // }
                            try {
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("User created"),
                                ));
                                print('User registered successufully');
                                // fToast.showToast(child: buildToast());
                                print(response.body);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) {
                                    return const ClientLogin();
                                  },
                                ));
                              } else {
                                print(
                                    'Error registering user ${response.statusCode}');
                                print(response.body);
                              }
                            } catch (e) {
                              print('Exception during API call: $e');
                            }

                            // Set the combined model to the provider
                            // Provider.of<SignUpDataProvider>(context, listen: false)
                            //     .submitForm();
                            //create account api
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
