import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({Key? key}) : super(key: key);

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _reason;

  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked.start != picked.end) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
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
              'Leave application submitted successfully',
            )),
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
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green.shade700, // Background color (constant)
                ),
                onPressed: () => _pickDateRange(context),
                child: Text(
                  _startDate == null
                      ? 'Select Date Range'
                      : 'From: ${DateFormat('yyyy-MM-dd').format(_startDate!)} To: ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green.shade700, // Background color (constant)
                ),
                onPressed: () => _pickTime(context, true),
                child: Text(
                  _startTime == null
                      ? 'Select Start Time'
                      : 'Start Time: ${_startTime!.format(context)}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green.shade700, // Background color (constant)
                ),
                onPressed: () => _pickTime(context, false),
                child: Text(
                  _endTime == null
                      ? 'Select End Time'
                      : 'End Time: ${_endTime!.format(context)}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reason for Leave',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason for your leave';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reason = value;
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Cancel Appointments',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      backgroundColor: Colors.green.shade700),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Instructions:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "- Please select the date range for your leave.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "- Choose the start and end time for your leave if applicable.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "- Provide a reason for your leave.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "- Click 'Apply Leave' to submit your request.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
