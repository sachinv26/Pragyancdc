import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/appointments.dart/my_appointment.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/clients/support/support_home.dart';
import 'package:pragyan_cdc/clients/wallet/wallet_screen.dart';

class DashBoard extends StatefulWidget {
  // BuildContext ctx;
  DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;

  late List<Widget> pages; // Declare but don't initialize here

  @override
  void initState() {
    super.initState();
    pages = [
      HomeScreen(), // Access widget.ctx after initialization
      const AppointmentScreen(),
      const SupportScreen(),
      const WalletScreen(),
    ];
  }

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
        elevation: 10,
        backgroundColor: Colors.white, // Set the background color to transparent
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green.shade600,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: 'My Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.contact_support_rounded,
            ),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet,
            ),
            label: 'Wallet',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

