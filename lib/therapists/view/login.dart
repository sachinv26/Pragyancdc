import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/dashboard.dart';

class TherapistLogin extends StatefulWidget {
  const TherapistLogin({super.key});

  @override
  State<TherapistLogin> createState() => _TherapistLoginState();
}

class _TherapistLoginState extends State<TherapistLogin> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.78),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/2 94701.png',
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const Text('Login to access your therapist account.'),
                    CustomTextFormField(
                      controller: _mobileController,
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      iconData: const Icon(Icons.phone),
                    ),
                    CustomTextFormField(
                      obscureText: true,
                      hintText: 'Password',
                      iconData: IconButton(
                        icon: const Icon(Icons.visibility_off),
                        onPressed: () {
                          PasswordToggle(
                            controller: _passwordController,
                          );
                        },
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password',
                        style: kTextStyle1,
                      ),
                    ),
                    CustomButton(
                        text: 'Login',
                        onPressed: () {
                          // if (_mobileController.text == '1234' &&
                          //     _passwordController.text == '1234') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TherapistDashBoard()));
                          // }
                          //  _login();
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New User? ', style: kTextStyle1),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/clientSignup');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
        //assets\images\2 94701.png
        );
  }
}
