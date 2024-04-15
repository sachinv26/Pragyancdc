import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/appointment_summary.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';

class ConsultationAppointment extends StatefulWidget {

  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyCost;
  ConsultationAppointment({Key? key, required this.branchId, required this.parentId, required this.childId, required this.therapistId, required this.therapyId, required this.therapyCost}) : super(key: key);
  @override
  State<ConsultationAppointment> createState() =>
      _ConsultationAppointmentState();
}

class _ConsultationAppointmentState extends State<ConsultationAppointment> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  DateTime? _selectedDate; // New

  List<String> timings = [
    '09:30',
    '10:15',
    '11:00',
    '11:45',
    '12:30',
    '14:00',
    '14:45',
    '15:30',
    '16:15',
    '17:00',
    '17:45',
    '18:30',
    '19:15'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Schedule Consultation'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 30),
              alignment: Alignment.center,
              child: const Text(
                'Weekend is not available, please select another date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          )
              : SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _timeSelected = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index ? Colors.green : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${timings[index]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                        _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: timings.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: CustomButton(
                width: double.infinity,
                onPressed: () {
                  if (_dateSelected && _timeSelected) {
                    String chosenTiming = timings[_currentIndex!]; // Get the selected timing
                    if (_selectedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                      String formattedTime = chosenTiming;
                      Map<String, List<String>> dateTimeMap = {formattedDate: [formattedTime]};
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppointment(
                            selecteddateslots: dateTimeMap, // Pass the dateTimeMap to the BookAppointment screen
                            branchId: widget.branchId,
                            parentId: widget.parentId,
                            childId: widget.childId,
                            therapistId: widget.therapistId,
                            therapyId: widget.therapyId,
                            therapyCost: widget.therapyCost,
                          ),
                        ),
                      );
                    }
                  }
                },
                text: 'Book Appointment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      weekendDays: [DateTime.sunday],
      focusedDay: _focusDay,
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      headerStyle: const HeaderStyle(
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.grey),
        rangeStartTextStyle: TextStyle(color: Colors.grey),
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle(color: Colors.grey),
        todayDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle),
      ),
      availableCalendarFormats: {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          _selectedDate = selectedDay;
          if (selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      }),
      lastDay: DateTime(2026, 12, 31),
      firstDay: DateTime.now(),
    );
  }
}
