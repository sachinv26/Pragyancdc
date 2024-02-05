import 'package:flutter/material.dart';
import 'package:pragyan_cdc/therapists/view/home.dart';

class UpcomingSchedule extends StatefulWidget {
  const UpcomingSchedule({super.key});

  @override
  State<UpcomingSchedule> createState() => _UpcomingScheduleState();
}

class _UpcomingScheduleState extends State<UpcomingSchedule> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  _showFilterOptions(context);
                },
                icon: const Icon(Icons.search)),
            Text(
              selectedOption != null
                  ? "Search: $selectedOption"
                  : "No Option Selected",
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        const Expanded(child: AppointmentDetails())
      ],
    );
  }

  Future<void> _showFilterOptions(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Filter Option'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Date');
              },
              child: const Text('Date'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Location');
              },
              child: const Text('Location'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedOption = result;
        if (selectedOption == 'Date') {
          _selectDate(context);
        } else if (selectedOption == 'Location') {
          _selectLocation(context);
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Handle selected date
      print("Selected Date: $picked");
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: const Text('Select Location'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Rajajinagar Branch '),
                  onTap: () {
                    Navigator.pop(context, 'Rajajinagar Branch');
                  },
                ),
                ListTile(
                  title: const Text('Nagarbhavi Branch'),
                  onTap: () {
                    Navigator.pop(context, 'Nagarbhavi Branch');
                  },
                ),
                ListTile(
                  title: const Text('HSR Branch'),
                  onTap: () {
                    Navigator.pop(context, 'HSR Branch');
                  },
                ),
                ListTile(
                  title: const Text('Marathahalli Branch'),
                  onTap: () {
                    Navigator.pop(context, 'Marathahalli Branch');
                  },
                ),
                ListTile(
                  title: const Text('Nagasandra Branch'),
                  onTap: () {
                    Navigator.pop(context, 'Nagasandra Branch');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      // Handle selected location
      print("Selected Location: $result");
    }
  }
}
