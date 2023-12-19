import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/client_api.dart';
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
  List<dynamic> branches = [];
  String parentErr = '';

  String childErr = '';

  String mailErr = '';
  String dobErr = '';
  var selectedBranchId = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic dropdownvalue;

  // List<Map<String, dynamic>> branches = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchLocations();

    // getBranchesData();
  }

  Future<List<dynamic>> fetchLocations() async {
    final response = await ApiServices().getBranches();
    return response['branch'];
  }

  @override
  Widget build(BuildContext context) {
    var signUpDataProvider = Provider.of<SignUpDataProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This ensures that the scaffold resizes when the keyboard opens
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 10, bottom: 10),
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
                    // kheight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Preferred Location',
                          style: khintTextStyle,
                        ),
                        FutureBuilder(
                          future: fetchLocations(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data;
                              //return Text(data![0]['bran_name ']);
                              return DropdownButton(
                                // hint: const Text('Preferred Location'),
                                //  isExpanded: true,
                                value: dropdownvalue ?? data![0]['bran_id'],
                                items: data!.map((location) {
                                  return DropdownMenuItem(
                                      value: location['bran_id'],
                                      child: Text(location['bran_name ']));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownvalue = value;
                                  });
                                },
                              );

                              // return DropdownButton(
                              //   //initial value
                              //   value: dropdownvalue ?? data['bran_id'][0],
                              //   // Down Arrow Icon
                              //   icon: const Icon(Icons.keyboard_arrow_down),
                              //   items: data.map((branch) {
                              //     return DropdownMenuItem(
                              //         value: branch['bran_id'],
                              //         child: Text(branch['bran_name ']));
                              //   }).toList(),

                              // onChanged: (value) {
                              //   dropdownvalue = value;
                              // },
                              // );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),

                    // DropdownButton(
                    //   //  isExpanded: true,
                    //   value: selectedBranchId,
                    //   items: branches.map<DropdownMenuItem<String>>((branch) {
                    //     return DropdownMenuItem(
                    //       value: branch['bran_id'],
                    //       child: Text(branch['bran_name '].toString().trim()),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     selectedBranchId = value as int;
                    //   },
                    // ),
                    // TextButton(
                    //     onPressed: () async {
                    //       final response = await ApiServices().getBranches();
                    //       // print('api response:');
                    //       // print(response);
                    //       List<dynamic> branches = response['branch'];
                    //       // print('branches:');
                    //       // print(branches);
                    //       for (var element in branches) {
                    //         print(element['bran_id']);
                    //         print(element['bran_name ']);
                    //       }
                    //     },
                    //     child: const Text('Click me')),

                    // DropdownButton<String>(
                    //   isExpanded: true,
                    //   value: selectedBranchId,
                    //   onChanged: (String? value) {
                    //     setState(() {
                    //       selectedBranchId = value;
                    //     });
                    //   },
                    //   items: branches.map<DropdownMenuItem<String>>((branch) {
                    //     return DropdownMenuItem(
                    //       value: branch['bran_id'],
                    //       child: Text(branch['bran_name'].toString().trim()),
                    //     );
                    //   }).toList(),
                    // ),
                    // FutureBuilder<List<Map<String, dynamic>>>(
                    //   future: getBranchesData(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const CircularProgressIndicator();
                    //     } else if (snapshot.hasError) {
                    //       return Text('Error: ${snapshot.error}');
                    //     } else if (!snapshot.hasData ||
                    //         snapshot.data!.isEmpty) {
                    //       return const Text('No data available');
                    //     } else {
                    //       List<Map<String, dynamic>> branches = snapshot.data!;

                    //       return DropdownButton(
                    //         isExpanded: true,
                    //         value: selectedBranchId,
                    //         onChanged: (dynamic value) {
                    //           // Ensure this matches your branch ID type
                    //           setState(() {
                    //             selectedBranchId = value;
                    //           });
                    //         },
                    //         items: branches
                    //             .map<DropdownMenuItem<dynamic>>((branch) {
                    //           // Ensure this matches your branch ID type
                    //           return DropdownMenuItem(
                    //             value: branch['bran_id'],
                    //             child: Text(branch['bran_name']
                    //                 .toString()
                    //                 .trim()), // Trim any extra spaces from bran_name key
                    //           );
                    //         }).toList(),
                    //       );
                    //     }
                    //   },
                    // ),
                    // DropdownButton(
                    //   isExpanded: true,
                    //   value: selectedBranchId,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedBranchId = value.toString();
                    //     });
                    //   },
                    //   items: branches.map((branch) {
                    //     return DropdownMenuItem(
                    //       value: branch['bran_id'],
                    //       child: Text(branch['bran_name']),
                    //     );
                    //   }).toList(),
                    // ),
                    // CustomTextFormField(
                    //   hintText: 'Preferred Location',
                    //   iconData: const Icon(Icons.location_on),
                    //   controller: signUpDataProvider.locationController,
                    // ),
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
