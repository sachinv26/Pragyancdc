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
                  Row(
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
                  Row(
                    children: [
                      const Column(
                        children: [],
                      ),
                      Container(
                          width: 1.0, // Adjust this width as needed
                          color: Colors.grey[300], // Change color as needed
                          height: 40 // Stretches to the full height
                          ),
                      const Column()
                    ],
                  )
                  //               Card(
                  //   elevation: 3,
                  //   child: Container(
                  //     margin: const EdgeInsets.all(8),

                  //     padding: const EdgeInsets.all(8),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Container(
                  //               padding: const EdgeInsets.all(10),
                  //               decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                   color:
                  //                       Colors.black,
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(5),
                  //               ),
                  //               child: Text(
                  //                 'Child Details',
                  //                 style: TextStyle(
                  //                   color:
                  //                    Colors.black,
                  //                 ),
                  //               ),
                  //             ),
                  //             Container(
                  //               padding: const EdgeInsets.all(10),
                  //               decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                   color:
                  //                      Colors.black,
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(5),
                  //               ),
                  //               child: Text(
                  //                 'Therapist Details',
                  //                 style: TextStyle(
                  //                   color:
                  //                     Colors.black,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(height: 10),
                  //        Column(
                  //                 children: List.generate(
                  //                   4,
                  //                   (index) => Column(
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           Text((index + 1).toString()),

                  //                           const SizedBox(width: 10),
                  //                           Text(
                  //                             _childNames[index],
                  //                             style: const TextStyle(fontSize: 14),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       kheight10
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   const Text('1 Amrtita Rao (Speech & language)'),
                  //                   kheight10,

                  //                   const Text('2 Amrtita (occupational)'),
                  //                   kheight10,

                  //                   const Text('3 Amrtita ((Behavior\'s education))'),

                  //                 ],
                  //               ),
                  //         kheight10,

                  //       ],
                  //     ),
                  //   ),
                  // ),
                  //  const TabsContainer()
                ],
              ),
            ]),
      ),
    );
  }
}
