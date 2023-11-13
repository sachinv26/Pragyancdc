import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/appointments.dart/my_appointment.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/clients/support/support.dart';
import 'package:pragyan_cdc/clients/wallet/wallet_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const AppointmentScreen(),
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
        body: pages[_currentIndex],
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                label: 'My Appointments',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.comment,
                  color: Colors.black,
                ),
                label: 'Support',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black,
                ),
                label: 'Wallet',
              ),
            ],
            onTap: _onItemTapped,
          ),
        ));
  }
}
