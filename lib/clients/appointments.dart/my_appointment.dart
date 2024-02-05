import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'My Appointment',
        showLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: 4,
            separatorBuilder: (context, index) {
              return kheight10;
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 221, 218, 218)),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Child',
                          style: kTextStyle1,
                        ),
                        kheight10,
                        const Text(
                          'Parent',
                          style: kTextStyle1,
                        ),
                        kheight10,
                        const Text(
                          'Visiting',
                          style: kTextStyle1,
                        ),
                        kheight10,
                        const Text(
                          'Location',
                          style: kTextStyle1,
                        ),
                        kheight10,
                        const Text(
                          'Booking',
                          style: kTextStyle1,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(': Arun'),
                        kheight10,
                        const Text(': Gawtham'),
                        kheight10,
                        const Text(': Speech & Language Therapy'),
                        kheight10,
                        const Text(': HSR Branch'),
                        kheight10,
                        const Text(': Pragyan75767')
                      ],
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
