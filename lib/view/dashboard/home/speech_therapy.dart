import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/view/dashboard/home/appointment/schedule_appointment_time.dart';

class SpeechTherapy extends StatelessWidget {
  SpeechTherapy({super.key});
  List<Map<String, String>> therapistData = [
    {
      'name': 'Dr. Amrita Rao',
      'category': 'Speech & Language Therapy',
    },
    {
      'name': 'Dr. Sangeeta',
      'category': 'Physiotherapy',
    },
    {
      'name': 'Dr. Tamilvani',
      'category': 'ABA Therapy/Behaviour Therapy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Speech & Language Therapy'),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.person_4_outlined),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'HSR Branch',
                  style: kTextStyle1,
                )
              ],
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.asset(
                  'assets/images/woman-doing-speech-therapy-with-little-boy-her-clinic 1.png'),
            ),
            kheight10,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Therapists List',
                  style: kTextStyle1,
                ),
                Text(
                  'See all',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            kheight10,
            Expanded(
                child: ListView.builder(
              itemCount: therapistData.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: TherapistCard(
                    name: therapistData[index]['name']!,
                    category: therapistData[index]['category']!,
                  ),
                );
              },
            )),
            // const CustomButton(
            //   text: 'Schedule',
            // )
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const ScheduleAppointment();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color (constant)
                minimumSize:
                    const Size(170, 40), // Width and height of the button
              ),
              child: const Text(
                'Schedule',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TherapistCard extends StatelessWidget {
  final String name;
  final String category;

  const TherapistCard({super.key, required this.name, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        width:
                            150, // Adjust the width here to control the space for the text
                        child: Text(
                          category,
                          style: kTextStyle3,
                          textAlign: TextAlign
                              .left, // Optional: Align the text in the center
                          maxLines:
                              2, // Optional: Allow maximum 2 lines for the text
                          overflow: TextOverflow
                              .ellipsis, // Optional: Handle overflow
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text('Experiences: '),
                          Text(
                            '5 years',
                            style: kTextStyle3,
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Text('Rating: '),
                          Text(
                            '⭐⭐⭐⭐',
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
