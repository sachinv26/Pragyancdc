import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/Today_client_details.dart';
import 'package:pragyan_cdc/therapists/view/upcoming_client_details.dart';
class UpcomingAppointmentDetails extends StatelessWidget {
  const UpcomingAppointmentDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const UpcomingClientDetails();
                },
              ));
            },
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border(
                      top: BorderSide(
                        color: Colors.green.shade700,
                        width: 4.0,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/images/cute_little_girl.png',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Child Name: Yuvaganesh',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        kheight10,
                        const Text(
                          'Parents Name: Baskaran',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        kheight10,
                        const Text(
                          'Status: New Client',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🕑: 11.30 AM',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        kheight10,
                        const Text('📆: 16/10/2023',
                            style: TextStyle(color: Colors.grey, fontSize: 11)),
                        kheight10,
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return kheight10;
        },
        itemCount: 5);
  }
}