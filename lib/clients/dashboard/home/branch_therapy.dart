import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/consultation_appointment.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/temp.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
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
  String selectedRepeatOption = 'No';
  int _value = 1;

  final List<String> _selectedChildren = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: widget.therapy.therapyName,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person),
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
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent, // Set color to transparent
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/womentherapy.png",
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            kheight30,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Row(
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
                      snapshot.data!['therapy'] != null &&
                      (snapshot.data!['therapy'] as List).isNotEmpty) {
                    List therapistData = snapshot.data!['therapy'];
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  text: 'Schedule Therapy',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Choose your child',
                              style: kTextStyle1,
                            ),
                            content: Container(
                              height: 170,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: 1,
                                          groupValue: _value,
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value!;
                                            });
                                          }),
                                      Text('Arun'),
                                    ],
                                  ),
                                  kheight10,
                                  Row(
                                    children: [
                                      Radio(
                                          value: 2,
                                          groupValue: _value,
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value!;
                                            });
                                          }),
                                      Text('Amit'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context);
                                          },
                                          child:
                                          Text('Cancel')),
                                      CustomButton(
                                        text: 'Done',
                                        onPressed: () {
                                          Navigator.pop(
                                              context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          ScheduleAppointment()));
                                        },
                                        width: 50,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                CustomButton(
                  text: 'Book Consultation',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Choose your child',
                              style: kTextStyle1,
                            ),
                            content: Container(
                              height: 170,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: 1,
                                          groupValue: _value,
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value!;
                                            });
                                          }),
                                      Text('Arun'),
                                    ],
                                  ),
                                  kheight10,
                                  Row(
                                    children: [
                                      Radio(
                                          value: 2,
                                          groupValue: _value,
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value!;
                                            });
                                          }),
                                      Text('Amit'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context);
                                          },
                                          child:
                                          Text('Cancel')),
                                      CustomButton(
                                        text: 'Done',
                                        onPressed: () {
                                          Navigator.pop(
                                              context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                      ConsultationAppointment()));
                                        },
                                        width: 50,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum SingingCharacter { arun, amit }

class TherapistCard extends StatefulWidget {
  final Therapist therapist;

  const TherapistCard({super.key, required this.therapist});

  @override
  State<TherapistCard> createState() => _TherapistCardState();
}

class _TherapistCardState extends State<TherapistCard> {
  String _selectedChild = 'Arun';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent, // Set color to transparent
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/psychologist.png",
                    fit: BoxFit.cover,
                    height: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.therapist.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('specialization: '),
                        Text(
                          widget.therapist.specialization,
                          style: kTextStyle3,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Description: '),
                        Text(
                          widget.therapist.description,
                          style: kTextStyle3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          kheight10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Experience : 5 Years',
              ),
              Text(
                'Rating : 5 stars',
              ),
            ],
          )
        ],
      ),
    );
  }
}
