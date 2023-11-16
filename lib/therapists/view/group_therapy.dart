import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class GroupTherapy extends StatefulWidget {
  const GroupTherapy({super.key});

  @override
  State<GroupTherapy> createState() => _GroupTherapyState();
}

class _GroupTherapyState extends State<GroupTherapy> {
  List<bool> checkedValues = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Group Therapy'),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location: HSR Branch',
              style: kTextStyle1,
            ),
            const Text('Appoint for this week:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Child Details',
                    style: kTextStyle1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Group Details',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const Text('Group List'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Group 3',
                  style: kTextStyle4,
                ),
                Text('📆 16/10/2023', style: kTextStyle5),
                Text('🕑 09:30-11:00 AM ', style: kTextStyle5),
                Text('HSR Layout', style: kTextStyle5)
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(children: [
                Row(
                  children: [
                    Column(children: [
                      Text(
                        'Child Details',
                        style: kTextStyle5,
                      ),
                      Column(
                        children: List.generate(
                          4, // Repeat the row 4 times
                          (index) => Row(
                            children: [
                              Text(
                                (index + 1).toString(),
                              ),
                              kwidth10,
                              const CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                  'assets/images/cute_little_girl.png',
                                ),
                              ),
                              kwidth10,
                              Text(
                                'Arun Gowtham',
                                style: kTextStyle4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])
                    // const VerticalDivider(
                    //   color: Colors.black,
                    //   thickness: 2,
                    //   width: 20,
                    //   indent: 200,
                    //   endIndent: 200,
                    // ),

                    // Column(
                    //   children: [
                    //     const Text('Therapist Details'),
                    //     const Text(' 1 Amrita Rao (Speech & Language)'),
                    //     // Row(
                    //     //   children: [
                    //     //     CheckboxListTile(
                    //     //       title: const Text('C1'),
                    //     //       value: checkedValues[0],
                    //     //       onChanged: (value) {
                    //     //         setState(() {
                    //     //           checkedValues[0] = value!;
                    //     //         });
                    //     //       },
                    //     //     ),
                    //     //     CheckboxListTile(
                    //     //       title: const Text('C2'),
                    //     //       value: checkedValues[1],
                    //     //       onChanged: (value) {
                    //     //         setState(() {
                    //     //           checkedValues[1] = value!;
                    //     //         });
                    //     //       },
                    //     //     ),
                    //     //     CheckboxListTile(
                    //     //       title: const Text('C3'),
                    //     //       value: checkedValues[2],
                    //     //       onChanged: (value) {
                    //     //         setState(() {
                    //     //           checkedValues[2] = value!;
                    //     //         });
                    //     //       },
                    //     //     ),
                    //     //     CheckboxListTile(
                    //     //       title: const Text('C4'),
                    //     //       value: checkedValues[3],
                    //     //       onChanged: (value) {
                    //     //         setState(() {
                    //     //           checkedValues[3] = value!;
                    //     //         });
                    //     //       },
                    //     //     ),
                    //     //   ],
                    //     // ),
                    //     const Text(' 2 Amrita Rao (Speech & Language)'),
                    //     const Text(' 3 Amrita Rao (Speech & Language)'),
                    //   ],
                    // )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Completed')),
                    kwidth10,
                    const Text(
                      'Edit',
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
