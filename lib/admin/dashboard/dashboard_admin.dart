import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pragyan_cdc/admin/dashboard/admin_appointments.dart';
import 'package:pragyan_cdc/admin/dashboard/appointment/admin_bookappointments.dart';
import 'package:pragyan_cdc/admin/dashboard/admin_home.dart';
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const AdminHome(),
    const AdminAppointments(),
    const AdminBookingAppointments(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userDoctor),
            label: 'Book Appointments',
          ),
        ],
        currentIndex: _currentIndex, // Set the initial selected index.
        onTap: (index) {
          _onItemTapped(index);
          // Handle navigation to different tabs.
          // You can navigate to different screens or update the content based on the selected tab.
        },
      ),
    );
  }
}
