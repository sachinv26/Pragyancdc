import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/components/button.dart';
import 'package:pragyan_cdc/therapists/view/widgets/upcoming_appointment_details.dart';
import 'package:expandable/expandable.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  TextEditingController _childNameController = TextEditingController();
  String? selectedOption;
  DateTime? selectedDate;
  DateTimeRange? selectedDateRange;
  bool showDateWidgets = false;
  bool showUpcomingAppointmentDetails = false;

  @override
  void dispose() {
    _childNameController.dispose(); // Dispose the controller when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: Text('Sort Appointments'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ExpandablePanel(
          header: Text('Filters'),
          collapsed: Container(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      showUpcomingAppointmentDetails = true;
                    });
                  },
                ),
              ],
            ),
          ),
          expanded: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _childNameController,
                decoration: InputDecoration(
                  labelText: 'Search Child Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownMenu(
                width: 400.0,
                label: const Text('Choose Status of the Appointment'),
                dropdownMenuEntries: <DropdownMenuEntry<Color>>[
                  DropdownMenuEntry(value: Colors.red, label: 'Upcoming'),
                  DropdownMenuEntry(value: Colors.purple, label: 'Completed'),
                  DropdownMenuEntry(value: Colors.pink, label: 'Select a Particular Date'),
                ],
                onSelected: (value) {
                  setState(() {
                    if (value == Colors.pink) {
                      showDateWidgets = true;
                      showUpcomingAppointmentDetails = false;
                    } else {
                      showDateWidgets = false;
                      showUpcomingAppointmentDetails = false; // Reset the flag when another option is selected
                    }
                    selectedOption = value.toString();
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    width: 190,
                    title: 'Search',
                    onPressed: () {
                      setState(() {
                        showUpcomingAppointmentDetails = true;
                      });
                    },
                    disable: false,
                  ),
                  if (showDateWidgets)
                    Button(
                      width: 190,
                      title: 'Choose a date',
                      onPressed: () {
                        _selectDate(context);
                      },
                      disable: false,
                    ),
                ],
              ),
              SizedBox(height: 10),
              if (showDateWidgets)
                Center(
                  child: Text(
                    selectedDate != null
                        ? 'Selected Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}'
                        : 'Please select a date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              if (showUpcomingAppointmentDetails)
                Container( // Here, I replaced Expanded with Container
                  child: UpcomingAppointmentDetails(), // You can adjust height constraints as needed
                ),
            ],
          ),
        ),
      ),
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
}


