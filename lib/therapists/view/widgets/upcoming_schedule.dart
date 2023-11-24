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
          title: const Text('Select Location'),
          content: Column(
            children: [
              ListTile(
                title: const Text('Location A'),
                onTap: () {
                  Navigator.pop(context, 'Location A');
                },
              ),
              ListTile(
                title: const Text('Location B'),
                onTap: () {
                  Navigator.pop(context, 'Location B');
                },
              ),
              ListTile(
                title: const Text('Location C'),
                onTap: () {
                  Navigator.pop(context, 'Location C');
                },
              ),
              ListTile(
                title: const Text('Location D'),
                onTap: () {
                  Navigator.pop(context, 'Location D');
                },
              ),
            ],
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
