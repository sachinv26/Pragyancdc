import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:pragyan_cdc/admin/today_appointments.dart';
import 'package:pragyan_cdc/admin/widgets/homeContainer.dart';
import 'package:pragyan_cdc/therapists/view/apply_leave.dart';
import 'package:pragyan_cdc/therapists/view/cancel_appointments.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Initial height when dropdowns are shown
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
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
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text('Apply leave'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ApplyLeave()));
              },
            ),
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Add more ListTile widgets or other widgets as needed
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0, // No elevation
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Admin Amrita Rao',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenSize.height * 0.25, // Responsive height
                          width: screenSize.width * 0.35,
                          child: Image.asset('assets/images/doctor1.png'),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text('Admin Amrita Rao',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Admin(RajajiNagar)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.green,
                            blurRadius: 8.0,
                            offset: Offset(2.0, 2.0))
                      ],
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border(
                        top: BorderSide(color: Colors.green.shade700, width: 3),
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AdminHomeContainer(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodayAppointments()));
                      },
                      title: 'Today\'s\nAppointments',
                      value: '14',
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: AdminHomeContainer(
                      title: 'Cancelled\nAppointments',
                      value: '2',
                    ),
                  ),
                ],
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AdminHomeContainer(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodayAppointments()));
                      },
                      title: 'Absentees',
                      value: '1',
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: AdminHomeContainer(
                      title: 'Empty Slots',
                      value: '2',
                    ),
                  ),
                ],
              ),
              Gap(10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/children.png',
                          fit: BoxFit.contain,
                        )),
                    Positioned(
                      left: 8,
                      top: 10,
                      child: Image.asset(
                        'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
