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
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: const Padding(
      //     padding: EdgeInsets.all(8.0),
      //     child: CircleAvatar(
      //       backgroundImage: AssetImage(
      //           'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
      //     ),
      //   ),
      //   title: const Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Amrita Rao',
      //         style: kTextStyle1,
      //       ),
      //       // You can add more details here, like the therapist's designation or status.
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         Icons.notifications,
      //         color: Colors.black,
      //       ),
      //       onPressed: () {
      //         // Handle notification icon press.
      //       },
      //     ),
      //   ],
      // ),
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
