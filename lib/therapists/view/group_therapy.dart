import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class GroupTherapy extends StatefulWidget {
  const GroupTherapy({super.key});

  @override
  State<GroupTherapy> createState() => _GroupTherapyState();
}

class _GroupTherapyState extends State<GroupTherapy> {
  final List<String> _childNames = [
    'Arun Gowtham',
    'Harish Subramani',
    'Ashok Balaji',
    'Suman Rahul'
  ];
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
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Appoint for this week:',
                  style: kTextStyle1,
                ),
              ),
              kheight10,
              const Center(
                  child: Text(
                'Group List',
                style: kTextStyle3,
              )),
              kheight10,
              Column(
                children: [
                  //container 1
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Group 3',
                          style: kTextStyle1,
                        ),
                        Text('📆 16/10/2023', style: kTextStyle5),
                        Text('🕑 09:30-11:00 AM ', style: kTextStyle5),
                        Text('HSR Layout', style: kTextStyle5)
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Child details',
                                  style: kTextStyle3,
                                ),
                                kheight10,
                                const Text('1. Arun Gowtham'),
                                kheight10,
                                const Text('2. Harish Subramani'),
                                kheight10,
                                const Text('3. Ashok Balaji'),
                                kheight10,
                                const Text('4. Suman Rahul')
                              ],
                            ),
                            kwidth10,
                            VerticalDivider(
                              color: Colors.grey[300],
                              width: 1.0,
                              thickness: 1.0,
                            ),
                            kwidth10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Therapist Details',
                                  style: kTextStyle3,
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '1. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Speech & Language)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '2. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Occupational)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '3. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Behavior\'s education)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //container 2
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Group 2',
                          style: kTextStyle1,
                        ),
                        Text('📆 16/10/2023', style: kTextStyle5),
                        Text('🕑 11:00-12:30 PM  ', style: kTextStyle5),
                        Text('HSR Layout', style: kTextStyle5)
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Child details',
                                  style: kTextStyle3,
                                ),
                                kheight10,
                                const Text('1. Arun Gowtham'),
                                kheight10,
                                const Text('2. Harish Subramani'),
                                kheight10,
                                const Text('3. Ashok Balaji'),
                                kheight10,
                                const Text('4. Suman Rahul')
                              ],
                            ),
                            kwidth10,
                            VerticalDivider(
                              color: Colors.grey[300],
                              width: 1.0,
                              thickness: 1.0,
                            ),
                            kwidth10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Therapist Details',
                                  style: kTextStyle3,
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '1. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Speech & Language)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '2. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Occupational)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '3. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Behavior\'s education)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //container 3
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Group 2',
                          style: kTextStyle1,
                        ),
                        Text('📆 16/10/2023', style: kTextStyle5),
                        Text('🕑 01:15-02:45 PM   ', style: kTextStyle5),
                        Text('HSR Layout', style: kTextStyle5)
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Child details',
                                  style: kTextStyle3,
                                ),
                                kheight10,
                                const Text('1. Arun Gowtham'),
                                kheight10,
                                const Text('2. Harish Subramani'),
                                kheight10,
                                const Text('3. Ashok Balaji'),
                                kheight10,
                                const Text('4. Suman Rahul')
                              ],
                            ),
                            kwidth10,
                            VerticalDivider(
                              color: Colors.grey[300],
                              width: 1.0,
                              thickness: 1.0,
                            ),
                            kwidth10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Therapist Details',
                                  style: kTextStyle3,
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '1. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Speech & Language)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '2. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Occupational)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                                kheight10,
                                Row(
                                  children: [
                                    const Text(
                                      '3. Amrita Rao',
                                    ),
                                    Text(
                                      ' (Behavior\'s education)',
                                      style: kTextStyle5,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
