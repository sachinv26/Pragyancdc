import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  DateTimeRange? selectedDateRange;

  bool _selectAll = false;
  List<bool> _appointmentSelections = List.generate(5, (index) => false);

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
        padding: EdgeInsets.all(1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leave Type',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
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
                          border: Border.all(
                            width: 1.5,
                            color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(1),
                          color: _selectedLeaveType == i ? Colors.green.shade700 : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            'General Leave',
                            style: TextStyle(
                              color: _selectedLeaveType == i ? Colors.white : Colors.black,
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
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () => _selectFrequency(i),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5,
                              color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(1),
                          color: _selectedFrequency == i ? Colors.green.shade700 : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            i == 0 ? 'Single Day' : (i == 1 ? 'Continuous Dates' : 'Half Day'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedFrequency == i ? Colors.white : Colors.black,
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
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 2; i++)
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () => _selectReason(i),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.black,
                            ),
                            color: _selectedReason == i ? Colors.green.shade700 : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: Center(
                            child: Text(
                              i == 0 ? 'Personal work' : 'Unwell',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedReason == i ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 20), // Adjust the width as needed
                ],
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Selected Dates:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  if (_selectedFrequency == 1 && selectedDateRange != null)
                    Text(
                      '${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - ${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}',
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
                      Icons.calendar_month_outlined,
                      size: 30,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildUpcomingAppointments(),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, // Set the color to green
                      width: 1, // Set the width as needed
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade700, // Set the color to green
                      width: 3, // Set the width as needed
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, // Set the color to green
                      width: 3, // Set the width as needed
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  Future<void> _selectHalfDay(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
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
                      _selectedDate = pickedDate;
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
                      _selectedDate = pickedDate;
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
    }
  }


  Widget _buildUpcomingAppointments() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 30),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text('Please Select the appointments you wish to cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          SizedBox(height: 5),
          Row(
            children: [
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
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border(
                            top: BorderSide(
                              color: Colors.green.shade700,
                              width: 4.0,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
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
                              const SizedBox(height: 10),
                              const Text(
                                'Parents Name: Baskaran',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
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
                              const SizedBox(height: 10),
                              const Text('📆: 16/10/2023', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 10),
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
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
