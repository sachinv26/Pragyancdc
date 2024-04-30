import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class SuccessfulPayment extends StatelessWidget {
  const SuccessfulPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Payment Success',showLeading: false),
      body: Center(
        child: Column(
          children: [
            kheight60,
            const Text(
              'Booking id \n pragyan75767',
              style: kTextStyle1,
            ),
            kheight60,
            Image.asset('assets/images/Group 10145.png'),
            kheight60,
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                        (route) => false, // Pop all routes and replace with the dashboard
                  );
                },
                text: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


