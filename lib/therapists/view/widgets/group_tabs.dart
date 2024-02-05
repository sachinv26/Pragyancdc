import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class TabsContainer extends StatefulWidget {
  const TabsContainer({super.key});

  @override
  _TabsContainerState createState() => _TabsContainerState();
}

class _TabsContainerState extends State<TabsContainer> {
  final List<String> _childNames = [
    'Arun Gowtham',
    'Harish Subramani',
    'Ashok Balaji',
    'Suman Rahul'
  ];
  bool c1 = false;
  bool c2 = false;
  bool c3 = false;
  bool c4 = false;
  bool isChildDetailsActive = true;
  bool isButtonActive = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isChildDetailsActive = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isChildDetailsActive ? Colors.green : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Child Details',
                      style: TextStyle(
                        color:
                            isChildDetailsActive ? Colors.green : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isChildDetailsActive = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            !isChildDetailsActive ? Colors.green : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Therapist Details',
                      style: TextStyle(
                        color:
                            !isChildDetailsActive ? Colors.green : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            isChildDetailsActive
                ? Column(
                    children: List.generate(
                      4,
                      (index) => Column(
                        children: [
                          Row(
                            children: [
                              Text((index + 1).toString()),
                              const SizedBox(width: 10),
                              const CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                    'assets/images/cute_little_girl.png'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _childNames[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          kheight10
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('1 Amrtita Rao (Speech & language)'),
                      kheight10,
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: CheckboxListTile(
                      //         contentPadding: EdgeInsets.zero,
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         dense: true,
                      //         title: const Text('c1'),
                      //         value: c1,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             c1 = value!;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: CheckboxListTile(
                      //         contentPadding: EdgeInsets.zero,
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         dense: true,
                      //         title: const Text('c2'),
                      //         value: c2,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             c2 = value!;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: CheckboxListTile(
                      //         contentPadding: EdgeInsets.zero,
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         dense: true,
                      //         title: const Text('c3'),
                      //         value: c3,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             c3 = value!;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: CheckboxListTile(
                      //         contentPadding: EdgeInsets.zero,
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         dense: true,
                      //         title: const Text('c4'),
                      //         value: c4,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             c4 = value!;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              final String checkboxText = 'c${index + 1}';
                              bool checkboxValue;

                              switch (index) {
                                case 0:
                                  checkboxValue = c1;
                                  break;
                                case 1:
                                  checkboxValue = c2;
                                  break;
                                case 2:
                                  checkboxValue = c3;
                                  break;
                                case 3:
                                  checkboxValue = c4;
                                  break;
                                default:
                                  throw Exception('Invalid index');
                              }

                              return SizedBox(
                                width: 75, // Adjust this width as needed
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  title: Text(checkboxText),
                                  value: checkboxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      switch (index) {
                                        case 0:
                                          c1 = value!;
                                          break;
                                        case 1:
                                          c2 = value!;
                                          break;
                                        case 2:
                                          c3 = value!;
                                          break;
                                        case 3:
                                          c4 = value!;
                                          break;
                                        default:
                                          throw Exception('Invalid index');
                                      }
                                    });
                                  },
                                ),
                              );
                            })),
                      ),
                      const Text('2 Amrtita (occupational)'),
                      kheight10,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              final String checkboxText = 'c${index + 1}';
                              bool checkboxValue;

                              switch (index) {
                                case 0:
                                  checkboxValue = c1;
                                  break;
                                case 1:
                                  checkboxValue = c2;
                                  break;
                                case 2:
                                  checkboxValue = c3;
                                  break;
                                case 3:
                                  checkboxValue = c4;
                                  break;
                                default:
                                  throw Exception('Invalid index');
                              }

                              return SizedBox(
                                width: 75, // Adjust this width as needed
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  title: Text(checkboxText),
                                  value: checkboxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      switch (index) {
                                        case 0:
                                          c1 = value!;
                                          break;
                                        case 1:
                                          c2 = value!;
                                          break;
                                        case 2:
                                          c3 = value!;
                                          break;
                                        case 3:
                                          c4 = value!;
                                          break;
                                        default:
                                          throw Exception('Invalid index');
                                      }
                                    });
                                  },
                                ),
                              );
                            })),
                      ),
                      const Text('3 Amrtita ((Behavior\'s education))'),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              final String checkboxText = 'c${index + 1}';
                              bool checkboxValue;

                              switch (index) {
                                case 0:
                                  checkboxValue = c1;
                                  break;
                                case 1:
                                  checkboxValue = c2;
                                  break;
                                case 2:
                                  checkboxValue = c3;
                                  break;
                                case 3:
                                  checkboxValue = c4;
                                  break;
                                default:
                                  throw Exception('Invalid index');
                              }

                              return SizedBox(
                                width: 75, // Adjust this width as needed
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  title: Text(checkboxText),
                                  value: checkboxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      switch (index) {
                                        case 0:
                                          c1 = value!;
                                          break;
                                        case 1:
                                          c2 = value!;
                                          break;
                                        case 2:
                                          c3 = value!;
                                          break;
                                        case 3:
                                          c4 = value!;
                                          break;
                                        default:
                                          throw Exception('Invalid index');
                                      }
                                    });
                                  },
                                ),
                              );
                            })),
                      ),
                    ],
                  ),
            kheight10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonActive
                            ? Colors.green
                            : const Color.fromARGB(255, 138, 147, 128)),
                    onPressed: () {
                      setState(() {
                        isButtonActive = !isButtonActive;
                      });
                    },
                    child: Text(
                      'Completed',
                      style: TextStyle(
                          color:
                              isButtonActive ? Colors.white : Colors.white38),
                    )),
                kwidth10,
                const Text(
                  'Edit',
                  style: TextStyle(color: Colors.blue),
                )
              ],
            )

            // ),
          ],
        ),
      ),
    );
  }
}
