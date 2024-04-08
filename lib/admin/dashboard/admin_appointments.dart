import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pragyan_cdc/admin/dashboard/appointment/today_appointments.dart';
import 'package:pragyan_cdc/admin/dashboard/appointment/upcoming_appointments.dart';
import 'package:pragyan_cdc/therapists/view/fliter.dart';
import '../../constants/styles/styles.dart';

class AdminAppointments extends StatefulWidget {
  const AdminAppointments({Key? key}) : super(key: key);

  @override
  State<AdminAppointments> createState() => _AdminAppointmentsState();
}

class _AdminAppointmentsState extends State<AdminAppointments> {
  late Widget _currentWidget;
  late Widget _appointmentDetailsWidget;
  late Widget _upcomingScheduleWidget;

  String _selectedBranch = 'Basavangudi Branch';
  late DateTime _selectedDate = DateTime.now();

  TextEditingController _childNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _appointmentDetailsWidget = TodayAppointments();
    _upcomingScheduleWidget = UpcomingAppointments();
    _currentWidget = _appointmentDetailsWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: Text(
          'Appointments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
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
                  SizedBox(height: 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(170, 30),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentWidget = _appointmentDetailsWidget;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Appointments',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(170, 30),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentWidget = _upcomingScheduleWidget;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Cancelled Appointments',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _selectedDate == DateTime.now()
                    ? Text(
                  'Please select a Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : Text(
                  'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(100, 30),
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _selectedDate == DateTime.now() ? SizedBox() : Expanded(child: _currentWidget),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
