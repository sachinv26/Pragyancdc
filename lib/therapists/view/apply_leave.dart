import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({Key? key}) : super(key: key);

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final TextEditingController _reasonController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();

  int _selectedFrequency = -1; // Variable to track selected frequency index
  int _selectedLeaveType = -1; // Variable to track selected leave type index
  int _selectedReason = -1; // Variable to track selected reason index
  String _selectedHalfDay = ''; // Variable to track selected half-day option

  void _selectFrequency(int index) {
    setState(() {
      _selectedFrequency = index;
    });

    if (_selectedFrequency == 0) {
      _selectDate(context);
    } else if (_selectedFrequency == 1) {
      _selectDateRange(context);
    } else if (_selectedFrequency == 2) {
      _selectHalfDay(context);
    }
  }

  void _selectLeaveType(int index) {
    setState(() {
      _selectedLeaveType = index;
    });
  }

  void _selectReason(int index) {
    setState(() {
      _selectedReason = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Apply Leave'),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave Type',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                for (int i = 0; i < 1; i++)
                  GestureDetector(
                    onTap: () => _selectLeaveType(i),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        border: Border.all(
                            color: _selectedLeaveType == i ? Colors.green.shade700 : Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          'General Leave',
                          style: TextStyle(
                            color: _selectedLeaveType == i ? Colors.green.shade700 : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Frequency',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 3; i++)
                  GestureDetector(
                    onTap: () => _selectFrequency(i),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          border: Border.all(color: Colors.black),
                          color: _selectedFrequency == i ? Colors.green.shade700 : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            i == 0
                                ? 'Single Day'
                                : (i == 1 ? 'Continuous Dates' : 'Half Day'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedFrequency == i ? Colors.white70 : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Reason For Leave',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                for (int i = 0; i < 2; i++)
                  GestureDetector(
                    onTap: () => _selectReason(i),
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedReason == i ? Colors.green.shade700 : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            i == 0 ? 'Personal work' : 'Unwell',
                            style: TextStyle(
                              color: _selectedReason == i ? Colors.white70 : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Select Dates',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                if (_selectedFrequency == 1 && _selectedDate is DateTimeRange)
                  Text(
                    '${(_selectedDate as DateTimeRange).start.day}/${(_selectedDate as DateTimeRange).start.month}/${(_selectedDate as DateTimeRange).start.year} - ${(_selectedDate as DateTimeRange).end.day}/${(_selectedDate as DateTimeRange).end.month}/${(_selectedDate as DateTimeRange).end.year}',
                    style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                  )
                else if (_selectedFrequency == 2 && _selectedHalfDay.isNotEmpty)
                  Text(
                    '$_selectedHalfDay, ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                  )
                else
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                  ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (_selectedFrequency == 0) {
                      _selectDate(context);
                    } else if (_selectedFrequency == 1) {
                      _selectDateRange(context);
                    } else if (_selectedFrequency == 2) {
                      _selectHalfDay(context);
                    }
                  },
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter reason',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  String reason = _reasonController.text;
                  // Do something with selected date and reason
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked as DateTime;
      });
    }
  }

  Future<void> _selectHalfDay(BuildContext context) async {
    final selectedHalfDay = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Half Day'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedHalfDay = 'Morning';
                  });
                  Navigator.pop(context, 'Morning');
                },
                child: Text('Morning'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedHalfDay = 'Evening';
                  });
                  Navigator.pop(context, 'Evening');
                },
                child: Text('Evening'),
              ),
            ],
          ),
        );
      },
    );
    if (selectedHalfDay != null) {
      setState(() {
        // Update selected date according to the half-day selected
        _selectedDate = DateTime.now();
      });
    }
  }
}
