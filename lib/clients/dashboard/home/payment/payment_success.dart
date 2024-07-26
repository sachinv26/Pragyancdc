import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class SuccessfulPayment extends StatelessWidget {
  const SuccessfulPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Payment Success', showLeading: true),
      body: Center(
        child: Column(
          children: [
            kheight60,
            const Text(
              'Booking id \n pragyan75767',
              style: kTextStyle1,
              textAlign: TextAlign.center,
            ),
            kheight60,
            Lottie.asset(
              'assets/animations/payment_success.json',
              width: 400,
              height: 200,
              fit: BoxFit.fill,
            ),
            kheight60,
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
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
