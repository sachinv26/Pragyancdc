import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/view/dashboard/dashboard.dart';

class SuccessfulPayment extends StatelessWidget {
  const SuccessfulPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const DashBoard();
                  }));
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber[50])),
                child: const Text(
                  'Done',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
