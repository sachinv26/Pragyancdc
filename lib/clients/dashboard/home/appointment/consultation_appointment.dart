import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ConsultationAppointment extends StatefulWidget {
  const ConsultationAppointment({Key? key}) : super(key: key);

  @override
  State<ConsultationAppointment> createState() => _ConsultationAppointmentState();
}

class _ConsultationAppointmentState extends State<ConsultationAppointment> {
  DateTime today = DateTime.now();
  DateTime? _selectedDate;
  String selectedDateRange = '';
  List<bool> isTappedList = List.filled(14, false); // Adjust the size based on the number of slots
  List<String> timeSlots = [
    '9.00-9.45', '9.45-10.30', '10.30-11.15', '11.15-12.00', '12.00-12.45',
    '12.45-13.30', '13.30-14.15', '14.15-15.00', '15.00-15.45', '15.45-16.30',
    '16.30-17.15', '17.15-18.00', '18.00-18.45', '18.45-19.30'
  ];

  void _updateSelectedDateRange() {
    if (_selectedDate == null) {
      selectedDateRange = '';
      return;
    }

    final formatter = DateFormat('dd MMM');
    selectedDateRange = formatter.format(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Spacer(),
            Text('Schedule Consultation', style: TextStyle(fontSize: 16)),
            Spacer(),
            Text(selectedDateRange, style: TextStyle(fontSize: 15, color: Colors.red)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0,bottom: 10.0,left: 10.0,right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 9, 1),
                  focusedDay: today,
                  lastDay: DateTime.utc(2029, 9, 1),
                  rowHeight: 38,
                  weekendDays: const [DateTime.sunday],
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableGestures: AvailableGestures.all,
                  onDaySelected: (selectedDate, focusedDate) {
                    setState(() {
                      _selectedDate = selectedDate;
                      _updateSelectedDateRange();
                      // Reset all slots to green when a new date is selected
                      isTappedList = List.filled(14, false);
                    });
                  },
                  selectedDayPredicate: (day) => _selectedDate == day,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (day.weekday == DateTime.sunday) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color.fromARGB(255, 199, 135, 130)),
                          ),
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      } else {
                        return null;
                      }
                    },
                    selectedBuilder: (context, date, events) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.green),
                          shape: BoxShape.rectangle,
                          color: Colors.red,
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, date, events) {
                      if (date == _selectedDate) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.blue),
                            shape: BoxShape.rectangle,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: Text('Appointment Timing', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              _buildSlotTiles(),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Book Appointment'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotTiles() {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 1,
      crossAxisSpacing: 15,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: timeSlots.map((slot) => _buildSlotTile(slot)).toList(),
      padding: const EdgeInsets.all(10),
    );
  }

  Widget _buildSlotTile(String slot) {
    int index = timeSlots.indexOf(slot);

    return GestureDetector(
      onTap: () {
        setState(() {
          // Reset all slots to green when a new date is selected
          for (int i = 0; i < isTappedList.length; i++) {
            isTappedList[i] = false;
          }
          // Toggle the tapped slot to red
          isTappedList[index] = true;
        });
      },
      child: Container(
        height: 30,
        width: 60,
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 0), // Adjust margin as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          color: isTappedList[index] ? Colors.red : Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            slot,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}


