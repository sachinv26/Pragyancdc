import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key});

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Child Name: Arun'),
                      kheight10,
                      const Text('Parent Name: Gowtham'),
                      kheight10,
                      const Text('DOB : 05/07/2000'),
                      kheight10,
                      const Text('Session : 🕑09:30 AM  📆 16/10/2023'),
                      kheight10,
                      const Text('Fees Amount : Paid'),
                    ],
                  )),
            ),
            kheight30,
            // const Text(
            //   'Status:',
            //   style: kTextStyle1,
            // ),
            // Card(
            //   elevation: 3,
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     width: double.infinity,
            //     height: 90,
            //     child: const Text('Notes:'),
            //   ),
            // ),
            FeesAmountRadioButtons(
              onChanged: (value) {},
              isPaid: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 97, 93, 93),
                    ),
                    onPressed: () {
                      TextEditingController reasonController =
                          TextEditingController();

                      showGeneralDialog(
                        transitionDuration: const Duration(milliseconds: 400),
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Container();
                        },
                        transitionBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return AlertDialog(
                            title: const Text('Notes'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller:
                                      reasonController, // Use the controller to manage the text field
                                  decoration: const InputDecoration(
                                    labelText: 'Enter reason',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the popup
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Handle submit logic
                                        print(reasonController
                                            .text); // Access the text field value using the controller
                                        Navigator.pop(
                                            context); // Close the popup
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none),
                          );
                        },
                      );
                    },
                    child: const Text('Pending')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                          (route) => route.settings.name == '/dashboard');
                    },
                    child: const Text('Completed'))
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
          activeColor: Colors.black,
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
