import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:pragyan_cdc/therapists/view/widgets/upcoming_appointment_details.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String _selectedBranch = 'All Branches';
  String _selectedtherapist = 'All Therapist';
  bool _loadingAppointments = false;
  bool _showDropdowns = true;
  double _dropdownHeight = 200; // Initial height when dropdowns are shown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          title: const Text(
            'Dr. Amrita Rao',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: _dropdownHeight,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (_showDropdowns) ...[
                              DropdownButton<String>(
                                alignment: Alignment.center,
                                borderRadius: BorderRadius.circular(10),
                                dropdownColor: Colors.green.shade700,
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
                                  'All Branches',
                                  'Basavangudi Branch',
                                  'Rajajinagar Branch',
                                  'Nagarbhavi Branch',
                                  'Marathahalli Branch'
                                ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: kTextStyle1,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 30),
                              DropdownButton<String>(
                                alignment: Alignment.center,
                                borderRadius: BorderRadius.circular(10),
                                dropdownColor: Colors.green.shade700,
                                hint: Text('choose a therapist'),
                                isExpanded: true,
                                elevation: 5,
                                value: _selectedtherapist,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedtherapist = newValue!;
                                  });
                                },
                                items: [
                                  'All Therapist',
                                  'Dr. Amrita Rao',
                                  'Dr. Rashmi',
                                  'Dr. Jaya',
                                  'Dr. Shilpa'
                                ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: kTextStyle1,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showDropdowns = !_showDropdowns;
                                    _loadingAppointments = true;
                                    _dropdownHeight = _showDropdowns ? 200 : 0; // Adjust height based on whether filters are collapsed or expanded
                                  });
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      _loadingAppointments = false;
                                    });
                                  });
                                },
                                child: Text(
                                  'Get Today Appointments',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _showDropdowns ? 0 : 40,
                    ),
                    Expanded(
                      child: _loadingAppointments
                          ? Center(child: Loading())
                          : UpcomingAppointmentDetails(),
                    ),
                  ],
                ),
                Positioned(
                  top: _showDropdowns ? 140 : 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        _showDropdowns ? '' : 'Today Appointments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _showDropdowns ? '' : 'Click to expand',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(_showDropdowns
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                        onPressed: () {
                          setState(() {
                            _dropdownHeight = _showDropdowns ? 0 : 200; // Adjust height based on whether filters are collapsed or expanded
                            _showDropdowns = !_showDropdowns;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
