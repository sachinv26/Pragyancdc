import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/dashboard/admin_home.dart';
import 'package:pragyan_cdc/clients/support/support.dart';
import 'package:pragyan_cdc/clients/wallet/wallet_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const AdminHome(),
    const Center(
      child: Text('My Appointment'),
    ),
    const SupportScreen(),
    const WalletScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const AppDrawer(),
      //
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
            icon: Icon(Icons.event),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
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
