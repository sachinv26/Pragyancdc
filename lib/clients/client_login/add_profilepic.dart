import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AddProfilePic extends StatelessWidget {
  String? userImage;
  AddProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            children: [
              const Text(
                'Your account has been created successfully.',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              kheight30,
              const Text(
                'Now, add a profile picture.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              kheight60,
              Image.asset(
                  'assets/images/empty-user.jpeg'), // Replace with your empty user image asset

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) {
                        //     return const DashBoard();
                        //   },
                        // ));
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontSize: 21),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Select ',
                        style: TextStyle(fontSize: 21),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
