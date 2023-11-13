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
        padding: const EdgeInsets.only(left: 15, top: 35, right: 15),
        child: Column(
          children: [
            const Text(
              'Your Appointment Timing',
              style: kTextStyle1,
            ),
            kheight30,
            PhysicalModel(
              color: Colors.white,
              elevation: 8,
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
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(

//                       color: Colors.white,
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3))
//                 ],
//               ),

// //
//               child: Column(
//                 children: [
//                   kheight10,
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('📆 16/10/2023'),
//                       Text('🕝 09:30 AM'),
//                       Text('Morning')
//                     ],
//                   ),
//                   kheight10,
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('📆 17/10/2023'),
//                       Text('🕝 12:30 PM'),
//                       Text('Morning')
//                     ],
//                   ),
//                   kheight10,
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('📆 18/10/2023'),
//                       Text('🕝 09:30 AM'),
//                       Text('Morning')
//                     ],
//                   ),
//                   kheight10,
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('📆 19/10/2023'),
//                       Text('🕝 02:45 PM'),
//                       Text('Afternoon')
//                     ],
//                   ),
//                   kheight10,
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('📆 20/10/2023'),
//                       Text('🕝 01:15 PM'),
//                       Text('Morning')
//                     ],
//                   ),
//                   kheight10,
//                 ],
//               ),
//             ),
//             kheight30,
            // Card(
            //   elevation: 3,
            //   child: Column(
            //     children: [
            //       const Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           Text('Repeat Booking'),
            //           Icon(Icons.arrow_drop_down)
            //         ],
            //       ),
            //       kheight10,
            //       const Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           Text('Add Group Therapy'),
            //           Icon(Icons.arrow_drop_down)
            //         ],
            //       ),
            //       kheight10,
            //     ],
            //   ),
            // ),
            kheight60,
            kheight30,
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
