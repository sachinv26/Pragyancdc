import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/signup2.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/temp_signup_model.dart';

import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:provider/provider.dart';

class ClientSignUp extends StatefulWidget {
  final String phoneNumber;

  const ClientSignUp({required this.phoneNumber, super.key});

  @override
  State<ClientSignUp> createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  String parentErr = '';

  String childErr = '';

  String mailErr = '';
  String dobErr = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var signUpDataProvider = Provider.of<SignUpDataProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This ensures that the scaffold resizes when the keyboard opens
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        'Welcome Back!',
                        style: kTextStyle2,
                      ),
                    ),
                    kheight10,
                    const Text(
                      'Enroll to Pragyan',
                      style: kTextStyle1,
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Parent Name',
                      iconData: const Icon(Icons.person),
                      controller: signUpDataProvider.parentNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // return 'Please enter parent name';
                          setState(() {
                            parentErr = 'Please enter parent name';
                          });
                        }
                        return null;
                      },
                    ),

                    Text(
                      parentErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: ' Child Name',
                      iconData: const Icon(Icons.person),
                      controller: signUpDataProvider.childNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          childErr = 'Please enter child name';
                        }
                        return null;
                      },
                    ),
                    Text(
                      childErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    kheight10,
                    Row(
                      children: [
                        const Text(
                          'Child DOB',
                          style: khintTextStyle,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // Open date picker when tapping on Child DOB field
                              await _selectDate(context, signUpDataProvider);
                              // After date is selected, update the text field
                            },
                            child: CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    dobErr = 'Please select date of birth';
                                  });
                                }
                                return null;
                              },
                              hintText: 'DD/MM/YYYY',
                              controller: signUpDataProvider.childDOBController,
                              enabled: false,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      dobErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     await signUpDataProvider.getImage();
                    //   },
                    //   child: CustomTextFormField(
                    //       hintText: signUpDataProvider.imagePath != null
                    //           ? 'Image Selected'
                    //           : 'Upload Picture',
                    //       enabled: false,
                    //       iconData: const Icon(Icons.camera_alt)),
                    // ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Enter your Mail id',
                      iconData: const Icon(Icons.email),
                      controller: signUpDataProvider.mailIdController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                          setState(() {
                            mailErr = 'Please enter a valid email address';
                          });
                        }
                        return null;
                      },
                    ),

                    Text(
                      mailErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Preferred Location',
                      iconData: const Icon(Icons.location_on),
                      controller: signUpDataProvider.locationController,
                    ),
                    kheight10,

                    CustomTextFormField(
                      hintText: 'Address (Optional)',
                      controller: signUpDataProvider.addressController,
                    ),
                    kheight30,
                    Center(
                      child: CustomButton(
                        text: 'Next',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            TempModel tempModeltoPass = TempModel(
                              parentName:
                                  signUpDataProvider.parentNameController.text,
                              childName:
                                  signUpDataProvider.childNameController.text,
                              childDOB:
                                  signUpDataProvider.childDOBController.text,
                              mailId: signUpDataProvider.mailIdController.text,
                              location:
                                  signUpDataProvider.locationController.text,
                              address:
                                  signUpDataProvider.addressController.text,
                              mobileNumber: widget.phoneNumber,
                              //imagePath: signUpDataProvider.imagePath,
                            );
                            print(tempModeltoPass);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return SignupSecond(
                                  tempModel: tempModeltoPass,
                                );
                              },
                            ));
                          }
                          // Save data to temp model class

                          //print(tempModel);
                          // Set TempModel using TempModelProvider
                          // Provider.of<TempModelProvider>(context, listen: false)
                          //     .setTempModel(tempModel);

                          // // Navigate to the next screen with the data

                          // Navigator.pushNamed(context, '/clientSignupSecond',
                          //     arguments: tempModel);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          // Add kTextStyle1 here if needed
                        ),
                        InkWell(
                          onTap: () {
                            // Handle login tap
                          },
                          child: const Text(
                            ' Login',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to open date picker
  Future<void> _selectDate(
      BuildContext context, SignUpDataProvider signUpDataProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2012),
      firstDate: DateTime(2006),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      // Update the Child DOB field with the selected date
      signUpDataProvider.childDOBController.text =
          picked.toLocal().toString().split(' ')[0];
      // Save the selected date to the separate controller
      signUpDataProvider.childDOB = picked;
    }
  }
}
