import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0, // No elevation
            leading: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png',
              ),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
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
                ElevatedButton(
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
                ElevatedButton(
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
                              mainAxisSize: MainAxisSize.min,
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
                                    labelText: 'Child Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                        backgroundColor: Colors.green.shade700
                                      ),
                                      onPressed: () {
                                        // Add logic to apply filters
                                        String childName = _childNameController.text;
                                        String parentName = _parentNameController.text;
                                        // You can use childName and parentName for filtering
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Apply',style: TextStyle(color: Colors.white),),
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
