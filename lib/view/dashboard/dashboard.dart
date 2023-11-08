import 'package:flutter/material.dart';
import 'package:pragyan_cdc/view/dashboard/home/homescreen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const Center(child: Text('My Appointments')),
    const Center(child: Text('Support')),
    const Center(child: Text('Wallet')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/cute_little_girl.png'),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arun',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Gowtham',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
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
