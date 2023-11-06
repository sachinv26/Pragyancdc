import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';

class ClientLogin extends StatelessWidget {
  const ClientLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                Card(
                  elevation: 4, // Set the desired elevation value
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Set the desired border radius
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Mobile Number',
                        suffixIcon: Icon(Icons.phone),
                        border: InputBorder.none),
                  ),
                ),
                Card(
                  elevation: 4, // Set the desired elevation value
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Set the desired border radius
                  ),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility_off),
                          onPressed: () {
                            const PasswordToggle();
                          },
                        ),
                        border: InputBorder.none),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 40)),
                    onPressed: () {},
                    child: const Text('Login')),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New User? ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                )
              ],
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
