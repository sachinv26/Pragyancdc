import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pragyan_cdc/clients/dashboard/home/appointment/consultation_appointment_summary.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class ConsultationAppointment extends StatefulWidget {
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyCost;
  final String branchName;
  final String childname;
  final String therapistName;
  final String therapyName;
  ConsultationAppointment({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.therapistId,
    required this.therapyId,
    required this.therapyCost, required this.branchName, required this.childname, required this.therapistName, required this.therapyName,
  }) : super(key: key);

  @override
  State<ConsultationAppointment> createState() =>
      _ConsultationAppointmentState();
}
class _ConsultationAppointmentState extends State<ConsultationAppointment> {
  CalendarFormat _format = CalendarFormat.month;
  late DateTime _focusDay;
  late DateTime _currentDay;
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  DateTime? _selectedDate; // New
  List<String> timings = [
    '09:30:00',
    '10:15:00',
    '11:00:00',
    '11:45:00',
    '12:30:00',
    '13:15:00',
    '14:00:00',
    '14:45:00',
    '15:30:00',
    '16:15:00',
    '17:00:00',
    '17:45:00',
    '18:30:00',
    '19:15:00',
  ];
  List<String> bookedSlots = []; // Store booked slots
  bool isFetchingData = false; // Indicator for fetching data

  @override
  void initState() {
    super.initState();
    _focusDay = DateTime.now();
    _currentDay = DateTime.now();
    // Fetch booked slots data when widget initializes
    fetchTherapistAppointments();
  }

  // Fetch booked slots data
  // Fetch therapist appointments and schedule
  Future<void> fetchTherapistAppointments() async {
    setState(() {
      isFetchingData = true; // Set indicator to true when fetching starts
    });

    final String apiUrl =
        'https://app.cdcconnect.in/apiservice/consultation/get_therapistconsolidated_info';

    final Map<String, dynamic> body = {
      "prag_branch": "1",
      "prag_therapy": "1",
      "prag_therapiest": widget.therapistId,
      "prag_fromdate": DateFormat('yyyy-MM-dd').format(_currentDay),
      "prag_todate": DateFormat('yyyy-MM-dd').format(_currentDay),
      "prag_dateorder": 1
    };

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken =
      await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'Content-Type': 'application/json',
        };

        final response = await http.post(
          Uri.parse(apiUrl),
          body: json.encode(body),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          List<dynamic>? therapistDetail = responseData['therapist_detail'];
          List<dynamic>? therapistSchedule = responseData['therapist_schedule'];

          if (therapistDetail != null && therapistDetail.isNotEmpty) {
            // Extract therapist's working hours
            final therapistWorkingHours = therapistDetail[0];

            final firstShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['first_start']));
            final firstShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['first_end']));
            final secondShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['two_start']));
            final secondShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['two_end']));
            final thirdShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['third_start']));
            final thirdShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['third_end']));

            // Function to check if a time slot falls within a shift
            bool isWithinShift(TimeOfDay time, TimeOfDay shiftStart, TimeOfDay shiftEnd) {
              return time.hour >= shiftStart.hour && time.hour < shiftEnd.hour;
            }

            // Mark slots as red if they fall outside of working hours
            for (int i = 0; i < timings.length; i++) {
              final currentTimeSlot = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(timings[i]));

              // Check if the current slot falls outside of any shift
              if (!isWithinShift(currentTimeSlot, firstShiftStart, firstShiftEnd) &&
                  !isWithinShift(currentTimeSlot, secondShiftStart, secondShiftEnd) &&
                  !isWithinShift(currentTimeSlot, thirdShiftStart, thirdShiftEnd)) {
                setState(() {
                  bookedSlots.add(timings[i]); // Add the slot to bookedSlots
                });
              }
            }
          }

          if (therapistSchedule != null) {
            setState(() {
              bookedSlots = therapistSchedule
                  .map((appointment) =>
              '${appointment['appointment_date']} ${appointment['appointment_time']}')
                  .toList();
            });
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isFetchingData = false; // Set indicator to false when fetching ends
      });
    }
  }








  @override
  Widget build(BuildContext context) {
    print(bookedSlots);
    return Scaffold(
      appBar: customAppBar(title: 'Book Consultation'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _tableCalendar(),
                Padding(
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
          isFetchingData
              ? SliverToBoxAdapter(
            child: Loading(),
          )
              :
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final currentTimeSlot =
                    '${DateFormat('yyyy-MM-dd').format(_currentDay)} ${timings[index]}';
                final isBooked = bookedSlots.contains(currentTimeSlot);
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (!isBooked) {
                      setState(() {
                        _currentIndex = index;
                        _timeSelected = true;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Slot Already Booked'),
                            content: Text('This slot is already booked. Please select another time.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index ? Colors.white : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                          ? Colors.green
                          : isBooked
                          ? Colors.red
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${timings[index]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
                  },
              childCount: timings.length,
            ),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
            ),
          ), // If not fetching data, use an empty SliverToBoxAdapter
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              child: CustomButton(
                onPressed: () {
                  if (_dateSelected && _timeSelected) {
                    String chosenTiming = timings[_currentIndex!];
                    if (_selectedDate != null) {
                      String formattedDate =
                      DateFormat('yyyy-MM-dd').format(_selectedDate!);
                      String formattedTime = chosenTiming;
                      Map<String, List<String>> dateTimeMap = {
                        formattedDate: [formattedTime]
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookConsultation(
                            selecteddateslots:
                            dateTimeMap, // Pass the dateTimeMap to the BookAppointment screen
                            branchId: widget.branchId,
                            parentId: widget.parentId,
                            childId: widget.childId,
                            therapistId: widget.therapistId,
                            therapyId: widget.therapyId,
                            therapyCost: widget.therapyCost,
                            branchName: widget.branchName,
                            therapyName: widget.therapyName,
                            therapistName: widget.therapistName,
                            childname: widget.childname,
                          ),
                        ),
                      );
                    }
                  }
                },
                text: 'Make Appointment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      daysOfWeekVisible: true,
      weekendDays: [DateTime.sunday],
      focusedDay: _currentDay, // Set the focused day to current day
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
          shape: BoxShape.circle,
        ),
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
          // Fetch booked slots data when a new date is selected
          fetchTherapistAppointments();
        });
      }),
      firstDay: DateTime.now(),
      lastDay: DateTime(2026, 12, 31),
    );
  }
}
