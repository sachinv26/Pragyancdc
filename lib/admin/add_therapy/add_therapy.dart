import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/add_new_therapist.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AddTherapist extends StatefulWidget {
  const AddTherapist({super.key});

  @override
  State<AddTherapist> createState() => _AddTherapistState();
}

class _AddTherapistState extends State<AddTherapist>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _activeTherapistLists =
      true; //to control the background green color of the tab label

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Add therapist'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          LocationSearch(),
          kheight10,
          Expanded(
            child: Column(
              children: [
                TabBar(
                  onTap: (value) {
                    setState(() {
                      _activeTherapistLists = !_activeTherapistLists;
                    });
                  },
                  controller: _tabController,
                  tabs: [
                    Tab(
                        child: ContainerTabLabel(
                      label: 'Therapist List',
                      showGreen: _activeTherapistLists,
                    )),
                    Tab(
                        child: ContainerTabLabel(
                      label: 'Add Therapist',
                      showGreen: !_activeTherapistLists,
                    )),
                  ],
                  indicatorColor: Colors.green,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Content for 'Therapy Lists'
                      ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                            leading: CircleAvatar(
                                child: Image.asset(
                                    'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png')),
                            title: const Text('Dr. Amrita Rao'),
                            subtitle: const Text('Speech & Language Therapy'),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      title: const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                                        radius: 27,
                                      ),
                                      content: const Text(
                                          'Are you sure you want to delete this account?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Dismiss the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            // Handle account deletion logic here
                                            // ...

                                            Navigator.pop(
                                                context); // Dismiss the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ));
                        },
                      ),
                      // Content for 'Add Therapy'
                      const AddNewTherapist(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class ContainerTabLabel extends StatelessWidget {
  final String label;
  bool showGreen;

  ContainerTabLabel({required this.showGreen, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: showGreen
            ? Colors.green
            : const Color.fromARGB(255, 210, 195, 195), // Default color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: showGreen ? Colors.white : Colors.black, // Default text color
        ),
      ),
    );
  }
}
