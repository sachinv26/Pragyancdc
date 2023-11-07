import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class ClientLogin extends StatelessWidget {
  const ClientLogin({super.key});

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
                    const Text('Login to access your account.'),
                    const CustomTextFormField(
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      iconData: Icon(Icons.phone),
                    ),
                    CustomTextFormField(
                      obscureText: true,
                      hintText: 'Password',
                      iconData: IconButton(
                        icon: const Icon(Icons.visibility_off),
                        onPressed: () {
                          const PasswordToggle();
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
                    CustomButton(text: 'Login', onPressed: () {}),
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

class PasswordToggle extends StatefulWidget {
  const PasswordToggle({super.key});

  @override
  _PasswordToggleState createState() => _PasswordToggleState();
}

class _PasswordToggleState extends State<PasswordToggle> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }
}
