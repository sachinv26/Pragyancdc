import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/schedule_appointment_time.dart';

class SpeechTherapy extends StatefulWidget {
  const SpeechTherapy({super.key});

  @override
  State<SpeechTherapy> createState() => _SpeechTherapyState();
}

class _SpeechTherapyState extends State<SpeechTherapy> {
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

  String selectedRepeatOption = 'No';

  final List<String> _selectedChildren = [];

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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Schedule for:',
                        style: kTextStyle1,
                      ),
                      content: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            CheckboxListTile(
                              title: const Text('1. Arun '),
                              // value: _selectedChildren.contains('Arun'),
                              value: true,
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _selectedChildren.add(' Arun');
                                  } else {
                                    _selectedChildren.remove('Arun');
                                  }
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('2. Amrita'),
                              value: false,
                              //  value: _selectedChildren.contains('Amrita'),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _selectedChildren.add('Amrita ');
                                  } else {
                                    _selectedChildren.remove('Amrita');
                                  }
                                });
                              },
                            ),
                            kheight30,

                            Text('Repeat Booking: $selectedRepeatOption'),
                            kheight10,
                            DropdownButton<String>(
                              value: selectedRepeatOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRepeatOption = newValue!;
                                });
                              },
                              items: <String>[
                                'No',
                                '4 weeks',
                                '8 weeks',
                                '12 weeks'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16.0),

                            // Add more CheckboxListTile widgets for additional children
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const ScheduleAppointment();
                              },
                            ));
                            // Handle schedule button press here
                            // print('Schedule clicked with options:');
                            // print('Repeat Option: $_selectedRepeatOption');
                            // print('Selected Children: $_selectedChildren');
                            //Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        ),
                      ],
                    );
                  },
                );
              },
              //  {
              //   Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) {
              //       return const ScheduleAppointment();
              //     },
              //   ));
              // },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.green, // Background color (constant)
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
