import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/booking_dates.dart';

class AppointmentInfo extends StatelessWidget {
  const AppointmentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Appointment Cancel'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          // BookingInfo(),
          kheight30,
          Container(
            height: 60,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1)),
          ),
          kheight10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Cancel')),
              ElevatedButton(onPressed: () {}, child: const Text('Modify'))
            ],
          )
        ]),
      ),
    );
  }
}
