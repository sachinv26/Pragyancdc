import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/add_new_child.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/consultation_appointment.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class BranchTherapy extends StatefulWidget {
  const BranchTherapy({super.key});

  @override
  State<BranchTherapy> createState() => _BranchTherapyState();
}

class _BranchTherapyState extends State<BranchTherapy> {
  int _value = 0; // Updated initial value to 0
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

  void _showChildDialog(String buttonText) {
    TextEditingController searchController = TextEditingController();
    String searchValue = '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Choose your child',
                style: kTextStyle1,
              ),
              content: SingleChildScrollView(
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
                          },
                        ),
                        Text('Existing Child'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value!;
                            });
                          },
                        ),
                        Text('New Child'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        CustomButton(
                          text: 'Done',
                          onPressed: () {
                            Navigator.pop(context);
                            if (_value==1) {
                              _showExistingChildSearchDialog();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ScheduleAppointment(),
                              //   ),
                              // );
                            } else if (_value==2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddChild(phoneNumber: '9026634459'),
                                ),
                              );
                            }
                          },
                          width: 50,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Method to show dialog for searching existing child
  void _showExistingChildSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Search Existing Child'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter the Phone number',
                      hintText: 'Search...',
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Implement your search logic here
                        // You can use the entered value to filter the list of existing children
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Display search results or child list based on search logic
                  // Replace the Text widget below with the actual search results or child list widget
                  Text('Search results will appear here'),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                    CustomButton(text: 'Done',width: 70,onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ConsultationAppointment()));
                    },)
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Speech & Language Therapy'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
        child: Column(
          children: [
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
            kheight10,
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  text: 'Schedule Therapy',
                  onPressed: () {
                    _showChildDialog('Schedule Therapy');
                  },
                ),
                CustomButton(
                  text: 'Book Consultation',
                  onPressed: () {
                    _showChildDialog('Book Consultation');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TherapistCard extends StatelessWidget {
  final String name;
  final String category;

  const TherapistCard(
      {super.key, required this.name, required this.category});

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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        category,
                        style: kTextStyle3,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
