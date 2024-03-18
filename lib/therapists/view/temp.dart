import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/upcoming_client_details.dart'; // Assuming this is your custom AppBar

class CancelAppointments extends StatefulWidget {
  const CancelAppointments({Key? key}) : super(key: key);

  @override
  State<CancelAppointments> createState() => _CancelAppointmentsState();
}

class _CancelAppointmentsState extends State<CancelAppointments> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _appointmentDate; // Renamed to reflect single date selection
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _reason;
  bool _selectAll = false;
  List<bool> _appointmentSelections = List.generate(5, (index) => false);

  // Method to pick a single date
  Future<void> _pickAppointmentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        _appointmentDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you can implement your submission logic, such as sending data to a server or saving it locally
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Appointment cancellation submitted successfully',
          ),
        ),
      );
      Future.delayed(
        Duration(
          seconds: 1,
        ),
            () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Cancel Appointments',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15.0,bottom: 15.0,left: 10.0,right: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700, // Background color
                ),
                onPressed: () => _pickAppointmentDate(context),
                child: Text(
                  _appointmentDate == null
                      ? 'Select Appointment Date'
                      : 'Appointment Date: ${DateFormat('yyyy-MM-dd').format(_appointmentDate!)}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (_appointmentDate != null) // Only show if date is selected
                Column(
                  children: [
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700, // Background color
                      ),
                      onPressed: () => _pickTime(context, true),
                      child: Text(
                        _startTime == null
                            ? 'Select Start Time'
                            : 'Start Time: ${_startTime!.format(context)}',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700, // Background color
                      ),
                      onPressed: () => _pickTime(context, false),
                      child: Text(
                        _endTime == null
                            ? 'Select End Time'
                            : 'End Time: ${_endTime!.format(context)}',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              if (_startTime != null && _endTime != null) // Only show if both times are selected
                Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Please Select the appointments you wish to cancel', style: kTextStyle3),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Spacer(),
                        Checkbox(
                          onChanged: (value) {
                            setState(() {
                              _selectAll = value!;
                              _appointmentSelections = List.generate(5, (index) => value);
                            });
                          },
                          value: _selectAll,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text('Select All'),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Checkbox(
                              onChanged: (value) {
                                setState(() {
                                  _appointmentSelections[index] = value!;
                                });
                              },
                              value: _appointmentSelections[index],
                            ),
                            Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/images/cute_little_girl.png',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Child Name: Yuvaganesh',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        kheight10,
                                        const Text(
                                          'Parents Name: Baskaran',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        kheight10,
                                        const Text(
                                          'Status: New Client',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '🕑: 11.30 AM',
                                          style: TextStyle(color: Colors.grey, fontSize: 11),
                                        ),
                                        kheight10,
                                        const Text('📆: 16/10/2023', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                        kheight10,
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              if (_appointmentDate != null && _startTime != null && _endTime != null) // Only show if all fields are selected
                Column(
                  children: [
                    const SizedBox(height: 0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Reason for Cancellation',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reason for cancelling';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _reason = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Cancel Appointment',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          backgroundColor: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
