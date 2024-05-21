import 'package:flutter/material.dart';
import 'package:pragyan_cdc/therapists/view/home.dart';
import 'package:pragyan_cdc/therapists/view/my_appointments.dart';
import 'package:pragyan_cdc/therapists/view/widgets/drawer_therapist.dart';

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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TherapistAppDrawer(),
      //
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.green.shade700,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'My Appointments',
          ),
        ],
        currentIndex: _currentIndex, // Set the initial selected index.
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
