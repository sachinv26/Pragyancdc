import 'package:flutter/material.dart';
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
            const Text(
              'Select Your Perfect Account',
              style: kTextStyle2,
            ),
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                height: 50,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Parent Login',
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
            // const SizedBox(
            //   height: 30,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const TherapistLogin(),
            //       ),
            //     );
            //   },
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       color: Color.fromARGB(255, 19, 138, 23),
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(10),
            //       ),
            //     ),
            //     padding: const EdgeInsets.only(left: 10, right: 10),
            //     width: double.infinity,
            //     height: 50,
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Therapist Login',
            //           style: TextStyle(
            //               color: Colors.white, fontWeight: FontWeight.bold),
            //         ),
            //         CircleAvatar(
            //           child: Icon(Icons.person),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }
}
