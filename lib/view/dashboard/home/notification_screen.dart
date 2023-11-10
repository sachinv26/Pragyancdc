import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Notification'),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: ListView
            //  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (children: [
          const Text('Today'),
          kheight10,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                subtitle: const Text(
                  'Your therapy session is one day away.',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          kheight10,
          const Text('Yesterday'),
          kheight10,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset('assets/images/cute_little_girl.png'),
                ),
                subtitle: const Text(
                  'Your Booking Appointment is Confirm. \n Session Details : 09:30 AM ',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                subtitle: const Text(
                  'Your therapy session is one day away.',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                subtitle: const Text(
                  'Your therapy session is one day away.',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const Text('Older'),
          kheight10,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset('assets/images/cute_little_girl.png'),
                ),
                subtitle: const Text(
                  'Your Booking Appointment is Confirm. \n Session Details : 09:30 AM ',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                subtitle: const Text(
                  'Your therapy session is one day away.',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.asset(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                subtitle: const Text(
                  'Your therapy session is one day away.',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Text(
                  '17h',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
