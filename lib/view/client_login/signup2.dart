import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class SignupSecond extends StatelessWidget {
  const SignupSecond({super.key});

  @override
  Widget build(BuildContext context) {
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
                const CustomTextFormField(
                  hintText: 'Create Password',
                  obscureText: true,
                  iconData: Icon(Icons.visibility_off),
                ),
                const CustomTextFormField(
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const CustomTextFormField(
                  hintText: 'Mobile Number',
                  iconData: Icon(Icons.phone),
                ),
                kheight60,
                Center(
                    child: CustomButton(
                        text: 'Verify',
                        onPressed: () {
                          Navigator.pushNamed(context, '/getOtp');
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
