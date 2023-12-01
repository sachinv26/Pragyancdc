import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/signup2.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/temp_user_model.dart';
import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:provider/provider.dart';

class ClientSignUp extends StatelessWidget {
  const ClientSignUp({Key? key}) : super(key: key);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Center(
                    child: Text(
                      'Welcome Back!',
                      style: kTextStyle2,
                    ),
                  ),
                  const Text(
                    'Enroll to Pragyan',
                    style: kTextStyle1,
                  ),
                  CustomTextFormField(
                    hintText: 'Enter Parent Name',
                    iconData: const Icon(Icons.person),
                    controller: signUpDataProvider.parentNameController,
                  ),
                  CustomTextFormField(
                    hintText: 'Enter Your Child Name',
                    iconData: const Icon(Icons.person),
                    controller: signUpDataProvider.childNameController,
                  ),
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
                            hintText: 'DD/MM/YYYY',
                            controller: signUpDataProvider.childDOBController,
                            enabled: false,
                          ),
                        ),
                      )
                    ],
                  ),
                  CustomTextFormField(
                    hintText: 'Enter your Mail id',
                    iconData: const Icon(Icons.email),
                    controller: signUpDataProvider.mailIdController,
                  ),
                  CustomTextFormField(
                    hintText: 'Preferred Location',
                    iconData: const Icon(Icons.location_on),
                    controller: signUpDataProvider.locationController,
                  ),
                  CustomTextFormField(
                    hintText: 'Address (Optional)',
                    controller: signUpDataProvider.addressController,
                  ),
                  Center(
                    child: CustomButton(
                      text: 'Next',
                      onPressed: () {
                        // Save data to temp model class
                        TempModel tempModel = TempModel(
                          parentName:
                              signUpDataProvider.parentNameController.text,
                          childName:
                              signUpDataProvider.childNameController.text,
                          childDOB: signUpDataProvider.childDOBController.text,
                          mailId: signUpDataProvider.mailIdController.text,
                          location: signUpDataProvider.locationController.text,
                          address: signUpDataProvider.addressController.text,
                        );
                        //print(tempModel);
                        // Set TempModel using TempModelProvider
                        Provider.of<TempModelProvider>(context, listen: false)
                            .setTempModel(tempModel);

                        // // Navigate to the next screen with the data
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return SignupSecond();
                          },
                        ));
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
    );
  }

  // Function to open date picker
  Future<void> _selectDate(
      BuildContext context, SignUpDataProvider signUpDataProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      // Update the Child DOB field with the selected date
      signUpDataProvider.childDOBController.text =
          picked.toLocal().toString().split(' ')[0];
      // Save the selected date to the separate controller
      // childDOBDateController.text = picked.toLocal().toString().split(' ')[0];
    }
  }
}

// Model class to hold temporary data
class TempModel {
  final String parentName;
  final String childName;
  final String childDOB;
  final String mailId;
  final String location;
  final String address;

  TempModel({
    required this.parentName,
    required this.childName,
    required this.childDOB,
    required this.mailId,
    required this.location,
    required this.address,
  });
  @override
  String toString() {
    return 'TempModel(\n'
        '  parentName: $parentName,\n'
        '  childName: $childName,\n'
        '  childDOB: $childDOB,\n'
        '  mailId: $mailId,\n'
        '  location: $location,\n'
        '  address: $address\n'
        ')';
  }
}


// class ClientSignUp extends StatelessWidget {
//   const ClientSignUp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Center(
//                 child: Text(
//                   'Welcome Back!',
//                   style: kTextStyle2,
//                 ),
//               ),
//               const Text(
//                 'Enroll to Pragyan',
//                 style: kTextStyle1,
//               ),
//               const CustomTextFormField(
//                 hintText: 'Enter Parent Name',
//                 iconData: Icon(Icons.person),
//               ),
//               const CustomTextFormField(
//                 hintText: 'Enter Your Child Name',
//                 iconData: Icon(Icons.person),
//               ),
//               const Row(
//                 children: [
//                   Text(
//                     'Child DOB',
//                     style: khintTextStyle,
//                   ),
//                   SizedBox(
//                     width: 25,
//                   ),
//                   Expanded(
//                     child: CustomTextFormField(
//                       hintText: 'DD/MM/YYYY',
//                     ),
//                   )
//                 ],
//               ),
//               // const CustomTextFormField(
//               //   hintText: 'Add Child Photo ',
//               //   iconData: Icon(Icons.camera_alt),
//               // ),
//               const CustomTextFormField(
//                 hintText: 'Enter your Mail id',
//                 iconData: Icon(Icons.email),
//               ),
//               const CustomTextFormField(
//                 hintText: 'Preferred Location',
//                 iconData: Icon(Icons.location_on),
//               ),
//               const CustomTextFormField(hintText: 'Address (Optional)'),
//               Center(
//                   child: CustomButton(
//                       text: 'Next',
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/clientSignupSecond');
//                       })),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Already have an account? ',
//                     style: kTextStyle1,
//                   ),
//                   InkWell(
//                     onTap: () {},
//                     child: const Text(
//                       ' Login',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               )
//             ]),
//       ),
//     );
//   }
// }
