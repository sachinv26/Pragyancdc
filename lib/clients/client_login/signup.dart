import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class ClientSignUp extends StatelessWidget {
  const ClientSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
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
              const CustomTextFormField(
                hintText: 'Enter Parent Name',
                iconData: Icon(Icons.person),
              ),
              const CustomTextFormField(
                hintText: 'Enter Your Child Name',
                iconData: Icon(Icons.person),
              ),
              const Row(
                children: [
                  Text(
                    'Child DOB',
                    style: khintTextStyle,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      hintText: 'DD/MM/YYYY',
                    ),
                  )
                ],
              ),
              const CustomTextFormField(
                hintText: 'Add Child Photo ',
                iconData: Icon(Icons.camera_alt),
              ),
              const CustomTextFormField(
                hintText: 'Enter your Mail id',
                iconData: Icon(Icons.email),
              ),
              const CustomTextFormField(
                hintText: 'Preferred Location',
                iconData: Icon(Icons.location_on),
              ),
              const CustomTextFormField(hintText: 'Address (Optional)'),
              Center(
                  child: CustomButton(
                      text: 'Next',
                      onPressed: () {
                        Navigator.pushNamed(context, '/clientSignupSecond');
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: kTextStyle1,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      ' Login',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
