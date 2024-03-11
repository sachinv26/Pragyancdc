import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/fliter_appointments.dart';
import 'package:pragyan_cdc/therapists/view/widgets/appointment_details.dart';
import 'package:pragyan_cdc/therapists/view/widgets/upcoming_schedule.dart';

class TherapistHome extends StatefulWidget {
  const TherapistHome({Key? key}) : super(key: key);

  @override
  _TherapistHomeState createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome> {
  late Widget _currentWidget; // Holds the currently displayed widget
  late Widget _appointmentDetailsWidget;
  late Widget _upcomingScheduleWidget;
  String _selectedBranch = 'Basavangudi Branch';
  TextEditingController _childNameController = TextEditingController();
  TextEditingController _parentNameController = TextEditingController();

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Apply Leave'),
              onTap: () {
                // Add action for item 1
              },
            ),
            ListTile(
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
        preferredSize: const Size.fromHeight(60),
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
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Speech & Language Therapy',
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                TextField(
                                  controller: _childNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Search by Child Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(width: 10.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Colors.green.shade700),
                                      onPressed: () {
                                        // Add logic to apply filters
                                        String childName =
                                            _childNameController.text;
                                        String parentName =
                                            _parentNameController.text;
                                        // You can use childName and parentName for filtering
                                        Navigator.pop(context);
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>FilterAppointments()));
                                      },
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
