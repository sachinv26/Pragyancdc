import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

import 'package:pragyan_cdc/therapists/view/widgets/appointment_details.dart';

class MyAppointments extends StatelessWidget {
  const MyAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: ' Appointment Lists'),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Search By:'),
            kheight10,
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Pick a date',
                  suffixIcon: Icon(Icons.calendar_month)),
            ),
            kheight10,
            const Expanded(child: AppointmentDetails())
          ],
        ),
      ),
    );
  }
}
