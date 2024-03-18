import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/cancel_appointments.dart';
import 'package:pragyan_cdc/therapists/view/apply_leave.dart';

class TherapistHome extends StatefulWidget {
  const TherapistHome({Key? key}) : super(key: key);

  @override
  _TherapistHomeState createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.only(bottom: 15),
              decoration:  BoxDecoration(
                color: Colors.green.shade700,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Amrita Rao',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Speech and Language Therapist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Cancel Appointment'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CancelAppointments()));
              },
            ),
            ListTile(
              visualDensity:
              const VisualDensity(horizontal: 0, vertical: -4),
              title: Text('Apply leave'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ApplyLeave()));
              },
            ),
            ListTile(
              visualDensity:
              const VisualDensity(horizontal: 0, vertical: -4),
              title: Text('Logout'),
              onTap: () {
                // Add action for item 2
              },
            ),
            // Add more ListTile widgets or other widgets as needed
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.07),
        child: AppBar(
          backgroundColor: Colors.green.shade700,
          elevation: 0, // No elevation
          leading: IconButton(
            icon: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png',
              ),
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dr. Amrita Rao',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Speech & Language Therapy',
                maxLines: 2,
                style: TextStyle(
                  wordSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenSize.height * 0.25, // Responsive height
                          width: screenSize.width * 0.35,
                          child: Image.asset('assets/images/doctor1.png'),),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Text('Dr. Amrita Rao', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Speech and Language Therapy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.green.shade700, width: 5),
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              Gap(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming Appointments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('See All'),
                  ],
                ),
              ),
              Gap(10),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border(
                        top: BorderSide(
                          color: Colors.green.shade700,
                          width: 4.0,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                              'assets/images/cute_little_girl.png',
                            ),
                          ),
                          Gap(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Child Name: Yuvaganesh',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              kheight10,
                              const Text(
                                'Parents Name: Baskaran',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              kheight10,
                              const Text(
                                'Status: New Client',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🕑: 11.30 AM',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          kheight10,
                          const Text('📆: 16/10/2023',
                              style: TextStyle(color: Colors.grey, fontSize: 11)),
                          kheight10,
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Gap(10),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border(
                        top: BorderSide(
                          color: Colors.green.shade700,
                          width: 4.0,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                              'assets/images/cute_little_girl.png',
                            ),
                          ),
                          Gap(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Child Name: Yuvaganesh',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              kheight10,
                              const Text(
                                'Parents Name: Baskaran',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              kheight10,
                              const Text(
                                'Status: New Client',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🕑: 11.30 AM',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          kheight10,
                          const Text('📆: 16/10/2023',
                              style: TextStyle(color: Colors.grey, fontSize: 11)),
                          kheight10,
                        ],
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
