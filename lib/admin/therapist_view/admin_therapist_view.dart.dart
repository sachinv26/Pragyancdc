import 'package:flutter/material.dart';

import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class ViewTherapistList extends StatelessWidget {
  const ViewTherapistList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(title: 'Therapist List'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              children: [
                LocationSearch(),
                kheight10,
                Expanded(
                  child: ListView.builder(
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
                                      borderRadius: BorderRadius.circular(20)),
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
                ),
              ],
            ),
          ),
        ));
  }
}
