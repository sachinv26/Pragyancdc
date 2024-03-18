import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/widgets/upcoming_appointment_details.dart';

class UpcomingSchedule extends StatefulWidget {
  const UpcomingSchedule({Key? key}) : super(key: key);

  @override
  State<UpcomingSchedule> createState() => _UpcomingScheduleState();
}

class _UpcomingScheduleState extends State<UpcomingSchedule> {
  String? selectedOption;
  DateTime? selectedDate;
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? selectedOption == 'Select Date'
                  ? 'Selected Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}'
                  : 'Selected Range: ${DateFormat('dd-MM-yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd-MM-yyyy').format(selectedDateRange!.end)}'
                  : 'Please select a date',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: () {
                _showSelectDialog(context);
              },
              child: Text('Select'),
            ),
          ],
        ),
        kheight10,
        if (selectedDate != null || selectedDateRange!=null) Expanded(child: UpcomingAppointmentDetails()),
      ],
    );
  }

  Future<void> _showSelectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Select Date'),
                onTap: () {
                  Navigator.pop(context);
                  _selectDate(context);
                },
              ),
              ListTile(
                title: Text('Select Date Range'),
                onTap: () {
                  Navigator.pop(context);
                  _selectDateRange(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedOption = 'Select Date';
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedOption = 'Select Date Range';
        selectedDateRange = picked;
      });
    }
  }

}

