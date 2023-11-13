import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/appointments.dart/view_detailed_appointment.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'My Appointment'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Child & Parent Name:  Arun, Gowtham'),
                    kheight10,
                    const Text('visiting: Speech & Language Therapy'),
                    kheight10,
                    const Text('Location : HSR Branch'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Booking : Pragyan75767'),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AppointmentInfo()));
                              },
                              child: const Text(
                                'Modify',
                                style: kTextStyle1,
                              )),
                        ])
                  ],
                ),
              );
            },
          )),
    );
  }
}
