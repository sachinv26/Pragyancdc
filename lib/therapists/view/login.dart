import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/login.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TherapistLogin extends StatefulWidget {
  const TherapistLogin({super.key});

  @override
  State<TherapistLogin> createState() => _TherapistLoginState();
}

class _TherapistLoginState extends State<TherapistLogin> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Implement your authentication logic here.
    // Once authenticated, you can save the credentials.
    String mobile = _mobileController.text;
    String password = _passwordController.text;

    if ((mobile == '7777123456') && (password == 'dr123')) {
      _saveCredentials(mobile, password);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return const TherapistDashBoard();
        },
      ));
    }

    // Add the navigation logic here.
  }

  void _saveCredentials(String mobile, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', mobile);
    await prefs.setString('password', password);
  }

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
                      controller: _passwordController,
                      iconData: IconButton(
                        icon: const Icon(Icons.visibility_off),
                        onPressed: () {
                          // PasswordToggle(
                          //   controller: _passwordController,
                          // );
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
                          _login();
                          // if (_mobileController.text == '1234' &&
                          //     _passwordController.text == '1234') {

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
