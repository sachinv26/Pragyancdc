import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CancelAppointments extends StatefulWidget {
  const CancelAppointments({Key? key}) : super(key: key);

  @override
  State<CancelAppointments> createState() => _CancelAppointmentsState();
}

class _CancelAppointmentsState extends State<CancelAppointments> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _selectAll = false;
  List<bool> _appointmentSelections = List.generate(5, (index) => false);
  DateTime today = DateTime.now();
  String? _reason;
  late DateTime _focusedDay; // Add this line

  late TextEditingController _dateController;// Add this line

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _focusedDay = today; // Initialize focusedDay to today's date
    _dateController = TextEditingController(); // Initialize date controller
    _dateController.text = DateFormat('dd-MM-yyyy').format(today); // Set initial value of date controller
  }

  void _nextDay() {
    setState(() {
      _focusedDay = _focusedDay.add(Duration(days: 1));
      _dateController.text = DateFormat('dd-MM-yyyy').format(_focusedDay);
    });
  }

  void _previousDay() {
    setState(() {
      _focusedDay = _focusedDay.subtract(Duration(days: 1));
      _dateController.text = DateFormat('dd-MM-yyyy').format(_focusedDay);
    });
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
  void dispose() {
    _tabController.dispose();
    _dateController.dispose(); // Dispose the date controller
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: Text('Cancel Appointments',style: TextStyle(
          letterSpacing: 1.0,
          color: Colors.white,fontWeight: FontWeight.bold,
        ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingAppointments(),
          _buildPastAppointments(),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousDay,
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      _selectDate(context);
                    },
                    child: Text(
                      DateFormat('dd-MM-yyyy').format(_focusedDay), // Format the date as DD-MM-YYYY
                      style: TextStyle(fontWeight: FontWeight.bold), // Apply bold font
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextDay,
              ),
            ],
          ),
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
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: TextFormField(
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
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                'Cancel Appointment',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                backgroundColor: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastAppointments() {
    return SingleChildScrollView(

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousDay,
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      _selectDate(context);
                    },
                    child: Text(
                      DateFormat('dd-MM-yyyy').format(_focusedDay), // Format the date as DD-MM-YYYY
                      style: TextStyle(fontWeight: FontWeight.bold), // Apply bold font
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextDay,
              ),
            ],
          ),
          ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                            width: 50,
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
        ],
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: today,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _focusedDay)
      setState(() {
        _focusedDay = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
  }
}
