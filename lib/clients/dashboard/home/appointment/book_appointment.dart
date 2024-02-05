import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/booking_details.dart';

class BookAppointment extends StatelessWidget {
  const BookAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Book Appointment'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Note Your Appointment Timing:',
              style: kTextStyle1,
            ),
            kheight30,
            PhysicalModel(
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  kheight30,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('📆 16/10/2023'),
                      Text('🕝 09:30 AM'),
                      Text('Morning')
                    ],
                  ),
                  kheight10,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('📆 17/10/2023'),
                      Text('🕝 12:30 PM'),
                      Text('Morning')
                    ],
                  ),
                  kheight10,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('📆 18/10/2023'),
                      Text('🕝 09:30 AM'),
                      Text('Morning')
                    ],
                  ),
                  kheight10,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('📆 19/10/2023'),
                      Text('🕝 02:45 PM'),
                      Text('Afternoon')
                    ],
                  ),
                  kheight10,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('📆 20/10/2023'),
                      Text('🕝 01:15 PM'),
                      Text('Morning')
                    ],
                  ),
                  kheight30,
                ],
              ),
            ),
            kheight60,
//

            kheight10,
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BookingDetails()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color (constant)
                minimumSize:
                    const Size(170, 40), // Width and height of the button
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
