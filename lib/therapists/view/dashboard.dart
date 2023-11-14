import 'package:flutter/material.dart';
import 'package:pragyan_cdc/therapists/view/home.dart';

class TherapistDashBoard extends StatefulWidget {
  const TherapistDashBoard({super.key});

  @override
  _TherapistDashBoardState createState() => _TherapistDashBoardState();
}

class _TherapistDashBoardState extends State<TherapistDashBoard> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const TherapistHome(),
    const Center(
      child: Text('My Appointment'),
    ),
    const Center(
      child: Text('Group Therapy'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'My Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group Therapy',
          ),
        ],
        currentIndex: 0, // Set the initial selected index.
        onTap: (index) {
          _onItemTapped(index);
          // Handle navigation to different tabs.
          // You can navigate to different screens or update the content based on the selected tab.
        },
      ),
    );
  }
}
