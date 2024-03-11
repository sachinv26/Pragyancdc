import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class UpcomingClientDetails extends StatefulWidget {
  const UpcomingClientDetails({super.key});

  @override
  State<UpcomingClientDetails> createState() => _UpcomingClientDetailsState();
}

class _UpcomingClientDetailsState extends State<UpcomingClientDetails> {
  String _selectedStatus = 'Planned';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Client Details'),
      body: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(8),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset('assets/images/service-1.png'),
                    kwidth10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location : HSR Branch',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        kheight10,
                        const Text('Visiting : Speech & Language Therapy',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        kheight10,
                        const Text('Therapy : Dr. Amrita Rao',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        kheight10,
                        const Text('🕑 9:30 AM      📆16/10/2023',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ),
            ),
            kheight30,
            const Text(
              'Client Details: ',
              style: kTextStyle1,
            ),
            kheight10,
            Card(
              elevation: 3,
              child: Container(
                margin: const EdgeInsets.all(12),
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Child Name: Arun'),
                        kheight10,
                        const Text('Parent Name: Gowtham'),
                        kheight10,
                        const Text('DOB : 05/07/2000'),
                        kheight10,
                        const Text('Session : 🕑09:30 AM  📆 16/10/2023'),
                      ],
                    ),
                    ClipOval(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                        AssetImage("assets/images/cute_little_girl.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

