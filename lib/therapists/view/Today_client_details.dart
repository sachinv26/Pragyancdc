import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class TodayClientDetails extends StatefulWidget {
  const TodayClientDetails({super.key});

  @override
  State<TodayClientDetails> createState() => _TodayClientDetailsState();
}

class _TodayClientDetailsState extends State<TodayClientDetails> {
  String _selectedStatus = 'Completed';
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
                    // Image.asset('assets/images/service-1.png'),
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
            kheight30,
            const Text(
              'Notes:',
              style: kTextStyle1,
            ),
            kheight10,
            Card(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: 90,
                child: const Text('Notes:'),
              ),
            ),
            kheight30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status:',
                  style: kTextStyle1,
                ),
                kwidth10,
                DropdownButton<String>(
                  value: _selectedStatus, // Default value
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  items: <String>['Session Started','Completed','Canelled due to Child Absent']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),

            kheight10,
            // FeesAmountRadioButtons(
            //   onChanged: (value) {},
            //   isPaid: true,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FeesAmountRadioButtons extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool isPaid;

  const FeesAmountRadioButtons({
    Key? key,
    required this.onChanged,
    this.isPaid = false,
  }) : super(key: key);

  @override
  State<FeesAmountRadioButtons> createState() => _FeesAmountRadioButtonsState();
}

class _FeesAmountRadioButtonsState extends State<FeesAmountRadioButtons> {
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    isPaid = widget.isPaid;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Fees Amount'),
        const SizedBox(width: 10),
        Radio(
          value: true,
          groupValue: isPaid,
          activeColor: Colors.green,
          onChanged: (value) {
            setState(() {
              isPaid = value!;
              widget.onChanged(value);
            });
          },
        ),
        const Text('Paid'),
        const SizedBox(width: 10),
        Radio(
          value: false,
          groupValue: isPaid,
          activeColor: Colors.green,
          onChanged: (value) {
            setState(() {
              isPaid = value!;
              widget.onChanged(value);
            });
          },
        ),
        const Text('Unpaid'),
      ],
    );
  }
}
