import 'package:flutter/material.dart';
import 'package:pragyan_cdc/therapists/view/home.dart';

class UpcomingSchedule extends StatelessWidget {
  const UpcomingSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 6, 225, 119)),
          onPressed: () {
            //  _showFilterOptions(context);
          },
          child: const Text('Filter By '),
        ),
        const Expanded(child: AppointmentDetails())
      ],
    );
  }
}
