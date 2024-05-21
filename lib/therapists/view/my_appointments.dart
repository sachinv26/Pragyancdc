import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/apply_leave.dart';
import 'package:pragyan_cdc/therapists/view/cancel_appointments.dart';
import 'package:pragyan_cdc/therapists/view/fliter.dart';

import 'package:pragyan_cdc/therapists/view/widgets/appointment_details.dart';
import 'package:pragyan_cdc/therapists/view/widgets/upcoming_schedule.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  late Widget _currentWidget;
 // Holds the currently displayed widget
  late Widget _appointmentDetailsWidget;

  late Widget _upcomingScheduleWidget;

  String _selectedBranch = 'Basavangudi Branch';

  TextEditingController _childNameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Initialize widgets
    _appointmentDetailsWidget = AppointmentDetails();
    _upcomingScheduleWidget = UpcomingSchedule();
    // Initially display AppointmentDetails widget
    _currentWidget = _appointmentDetailsWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green.shade700,
          elevation: 0, // No elevation
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Appointments',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: DropdownButton<String>(
                hint: Text('choose a branch'),
                isExpanded: true,
                elevation: 5,
                value: _selectedBranch,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBranch = newValue!;
                  });
                },
                items: [
                  'Basavangudi Branch',
                  'Rajajinagar Branch',
                  'Nagarbhavi Branch',
                  'Marathahalli Branch'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: kTextStyle1,
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      fixedSize: const Size(170, 30),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentWidget = _appointmentDetailsWidget;
                      });
                    },
                    child: const Text(
                      'Today Appointments',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
                Gap(10),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      fixedSize: const Size(170, 30),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentWidget = _upcomingScheduleWidget;
                      });
                    },
                    child: const Text(
                      'Upcoming Schedule',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>FiltersScreen()));
                  },
                  icon: Icon(Icons.filter_list),
                ),
              ],
            ),
            const SizedBox(height: 10), // Add spacing between buttons and content
            Expanded(
              child: _currentWidget, // Display the currently selected widget
            ),
          ],
        ),
      ),
    );
  }
}
