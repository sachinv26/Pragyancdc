import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/therapists/view/home.dart';
import 'package:pragyan_cdc/therapists/view/my_appointments.dart';

class TherapistDashBoard extends StatefulWidget {
  const TherapistDashBoard({super.key});

  @override
  _TherapistDashBoardState createState() => _TherapistDashBoardState();
}

class _TherapistDashBoardState extends State<TherapistDashBoard> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const TherapistHome(),
    const MyAppointments(),
    const Center(
      child: Text('This is for Group Therapy '),
    )
    //const GroupTherapy(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
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
