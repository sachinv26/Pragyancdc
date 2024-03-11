import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/admin_login.dart';
import 'package:pragyan_cdc/clients/auth_wrapper.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/login.dart';

class SignupSelection extends StatelessWidget {
  const SignupSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Welcome Back!', style: kTextStyle2),
            const SizedBox(
              height: 30,
            ),
            Image.asset('assets/images/Pragyan_Logo.png'),
            const SizedBox(
              height: 30,
            ),
            const Text('Select Your Perfect Account'),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AuthWrapper();
                    },
                  ),
                );
                //   Navigator.pushNamed(context, '/clientLogin');
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 19, 138, 23),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.only(left: 7, right: 4),
                width: double.infinity,
                height: 40,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'For Parent',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TherapistLogin(),
                  ),
                );
              },
              child: ListTile(
                leading: Image.asset('assets/images/Group 10128.png'),
                title: const Text(
                  'Therapist Only',
                  style: khintTextStyle,
                ),
                trailing: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 7,
                    child: CircleAvatar(
                      radius: 5,
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminLogin();
                    },
                  ),
                );
              },
              child: ListTile(
                leading: Image.asset('assets/images/Vector (1).png'),
                title: const Text(
                  'Admin Only',
                  style: khintTextStyle,
                ),
                trailing: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 7,
                  child: CircleAvatar(
                    radius: 5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
