import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/schedule_appointment_time.dart';
import 'package:pragyan_cdc/model/therapist_model.dart';
import 'package:pragyan_cdc/model/therapy_model.dart';

class BranchTherapies extends StatefulWidget {
  final Therapy therapy;
  final String branchId;
  final String branchName;
  const BranchTherapies(
      {required this.therapy,
      required this.branchId,
      required this.branchName,
      super.key});

  @override
  State<BranchTherapies> createState() => _BranchTherapiesState();
}

class _BranchTherapiesState extends State<BranchTherapies> {
  // List<Map<String, String>> therapistData = [
  //   {
  //     'name': 'Dr. Amrita Rao',
  //     'category': 'Speech & Language Therapy',
  //   },
  //   {
  //     'name': 'Dr. Sangeeta',
  //     'category': 'Physiotherapy',
  //   },
  //   {
  //     'name': 'Dr. Tamilvani',
  //     'category': 'ABA Therapy/Behaviour Therapy',
  //   },
  // ];

  String selectedRepeatOption = 'No';

  final List<String> _selectedChildren = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: widget.therapy.therapyName),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.person_4_outlined),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  widget.branchName,
                  style: kTextStyle1,
                )
              ],
            ),
            kheight10,
            // PhotoView(
            //   imageProvider: NetworkImage(widget.therapy.therapyIcon),

            // ),
            Image.network(
              widget.therapy.therapyIcon,
              width: 240,
              //  cacheWidth: 500,
              fit: BoxFit.fill,
            ),
            // ClipRRect(
            //   borderRadius: const BorderRadius.all(Radius.circular(15)),
            //   child: Image.network(widget.therapy.therapyIcon),
            //   // child: Image.asset(
            //   //     'assets/images/woman-doing-speech-therapy-with-little-boy-her-clinic 1.png'),
            // ),
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
            FutureBuilder(
                future: TherapistApi()
                    .fetchTherapists(widget.branchId, widget.therapy.therapyId),
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while fetching data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show an error message if fetching data fails
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData &&
                      snapshot.data!['theropy'] != null &&
                      (snapshot.data!['theropy'] as List).isNotEmpty) {
                    List therapistData = snapshot.data!['theropy'];

                    return Expanded(
                      child: ListView.builder(
                        itemCount: therapistData.length,
                        itemBuilder: (BuildContext context, int index) {
                          Therapist therapist =
                              Therapist.fromJson(therapistData[index]);

                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: TherapistCard(
                              therapist: therapist,
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                }),
            // Expanded(
            //     child: ListView.builder(
            //   itemCount: therapistData.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Container(
            //       margin: const EdgeInsets.all(10),
            //       child: TherapistCard(
            //       branchId: widget.branchId,
            //       therapy: widget.therapy,
            //       ),
            //     );
            //   },
            // )),
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
  final Therapist therapist;

  const TherapistCard({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                "https://askmyg.com/${therapist.image}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      therapist.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 150,
                      child: Text(
                        therapist.specialization,
                        style: kTextStyle3,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Description: '),
                        Text(
                          therapist.description,
                          style: kTextStyle3,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Cost: '),
                        Text(therapist.cost),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
