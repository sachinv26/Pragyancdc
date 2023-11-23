import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_modes.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Book Appointment'),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm your Booking Details:',
              style: kTextStyle1,
            ),

            BookingInfo(),

            kheight30,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Total amount',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    kheight10,
                    const Text(
                      '1200 Rs',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            // const Text(
            //   'Select Payment Method',
            //   style: kTextStyle1,
            // ),
            // const ListTile(
            //   contentPadding: EdgeInsets.all(5),
            //   leading: Text('Pay on Online modes'),
            //   trailing: Icon(
            //     Icons.radio_button_checked,
            //     color: Colors.green,
            //   ),
            // ),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(170, 40)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PaymentModes()));
                    },
                    child: const Text('Proceed to Pay')))
          ],
        ),
      ),
    );
  }
}

Widget BookingInfo() {
  return Card(
    elevation: 3,
    child: Container(
      padding: const EdgeInsets.all(10),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text('Child Name:'), Text('Arun')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text('Parent Name:'), Text('Gowtham')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text('DOB :'), Text('05/07/2000')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text('Mobile Number :'), Text('9876543210')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text('Session'), Text(' 📆 16/10/2023 , 21/10/2023')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🕝 09:30 AM , 12:30 PM , 01 :15 PM '),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text('Location:'), Text('HSR Branch')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text(' Visiting:'), Text('Speech & Language Therapy')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text(' Therapy:'), Text('Dr. Amrita Rao')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text(' Repeat Booking :'), Text('None')],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [Text(' Add Group Therapy  :'), Text(' No')],
            ),
          ),
        ],
      ),
    ),
  );
}
