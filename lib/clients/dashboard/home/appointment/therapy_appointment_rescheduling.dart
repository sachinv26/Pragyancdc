import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class RescheduleAppointment extends StatefulWidget {
  final String? branchId;
  final String? parentId;
  final String? childId;
  final String? therapistId;
  final String? therapyId;
  RescheduleAppointment({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.therapistId,
    required this.therapyId,
  }) : super(key: key);

  @override
  State<RescheduleAppointment> createState() =>
      _RescheduleAppointmentState();
}
class _RescheduleAppointmentState extends State<RescheduleAppointment> {
  CalendarFormat _format = CalendarFormat.month;
  late DateTime _focusDay;
  late DateTime _currentDay;
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
    '13:15',
    '14:00',
    '14:45',
    '15:30',
    '16:15',
    '17:00',
    '17:45',
    '18:30',
    '19:15',
  ];
  List<String> bookedSlots = []; // Store booked slots
  bool isFetchingData = false;

  TimeOfDay? firstShiftStart;
  TimeOfDay? firstShiftEnd;
  TimeOfDay? secondShiftStart;
  TimeOfDay? secondShiftEnd;
  TimeOfDay? thirdShiftStart;
  TimeOfDay? thirdShiftEnd;

  @override
  void initState() {
    super.initState();
    _focusDay = DateTime.now();
    _currentDay = DateTime.now();
    // Fetch booked slots data when widget initializes
    fetchTherapistAppointments();
  }




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
          'pragusercallfrom':"parent",
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

          // Clear booked slots before updating
          setState(() {
            bookedSlots.clear();
            firstShiftStart = null;
            firstShiftEnd = null;
            secondShiftStart = null;
            secondShiftEnd = null;
            thirdShiftStart = null;
            thirdShiftEnd = null;
          });

          if (therapistDetail != null && therapistDetail.isNotEmpty) {
            final therapistWorkingHours = therapistDetail[0];

            setState(() {
              firstShiftStart = therapistWorkingHours['first_start'] != null
                  ? TimeOfDay.fromDateTime(
                  DateFormat('HH:mm').parse(therapistWorkingHours['first_start']))
                  : null;
              firstShiftEnd = therapistWorkingHours['first_end'] != null
                  ? TimeOfDay.fromDateTime(
                  DateFormat('HH:mm').parse(therapistWorkingHours['first_end']))
                  : null;
              secondShiftStart = therapistWorkingHours['two_start'] != null
                  ? TimeOfDay.fromDateTime(
                  DateFormat('HH:mm').parse(therapistWorkingHours['two_start']))
                  : null;
              secondShiftEnd = therapistWorkingHours['two_end'] != null
                  ? TimeOfDay.fromDateTime(
                  DateFormat('HH:mm').parse(therapistWorkingHours['two_end']))
                  : null;
              thirdShiftStart = therapistWorkingHours['third_start'] != null
                  ? TimeOfDay.fromDateTime(
                  DateFormat('HH:mm').parse(therapistWorkingHours['third_start']))
                  : null;
              thirdShiftEnd = therapistWorkingHours['third_end'] != null
                  ? TimeOfDay.fromDateTime(
                  DateFormat('HH:mm').parse(therapistWorkingHours['third_end']))
                  : null;
            });
          }

          if (therapistSchedule != null) {
            setState(() {
              bookedSlots = therapistSchedule
                  .map((appointment) =>
              '${appointment['appointment_date']} ${appointment['appointment_time'].toString().substring(0, 5)}')
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

  bool isWithinShift(DateTime dateTime) {
    TimeOfDay slotTime = TimeOfDay.fromDateTime(dateTime);
    print('Checking if $slotTime is within shift...');

    List<TimeOfDay?> shiftStartTimes = [
      firstShiftStart,
      secondShiftStart,
      thirdShiftStart,
    ];
    List<TimeOfDay?> shiftEndTimes = [
      firstShiftEnd,
      secondShiftEnd,
      thirdShiftEnd,
    ];

    shiftStartTimes = shiftStartTimes.whereType<TimeOfDay>().toList();
    shiftEndTimes = shiftEndTimes.whereType<TimeOfDay>().toList();

    for (int i = 0; i < shiftStartTimes.length; i++) {
      TimeOfDay? startTime = shiftStartTimes[i];
      TimeOfDay? endTime = shiftEndTimes[i];

      if (startTime == null || endTime == null) {
        print('Skipping shift $i because start or end time is null');
        continue;
      }
      print('Checking shift $i (${startTime.format(context)} - ${endTime.format(context)})');

      if ((slotTime.hour > startTime.hour ||
          (slotTime.hour == startTime.hour && slotTime.minute >= startTime.minute)) &&
          (slotTime.hour < endTime.hour ||
              (slotTime.hour == endTime.hour && slotTime.minute < endTime.minute))) {
        print('$slotTime is within shift $i');
        return true;
      } else if (slotTime.hour < endTime.hour) {
        print('$slotTime is between midnight and the end time of shift $i');
        return true;
      } else if (slotTime.hour >= endTime.hour) {
        if (i == shiftStartTimes.length - 1) {
          print('$slotTime is after the end of the last shift');
          return false;
        } else {
          TimeOfDay? nextStartTime = shiftStartTimes[i + 1];
          if (nextStartTime != null &&
              (slotTime.hour > endTime.hour ||
                  (slotTime.hour == endTime.hour && slotTime.minute >= endTime.minute))) {
            if (slotTime.hour < nextStartTime.hour ||
                (slotTime.hour == nextStartTime.hour && slotTime.minute < nextStartTime.minute)) {
              print('$slotTime is between the end of shift $i and the start of shift ${i + 1}');
              return false; // Time slot is outside of any shift
            }
          }
        }
      }
    }

    print('$slotTime is not within any shift');
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Reschedule Appointment'),
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
                final timingString = timings[index];
                final currentTimeSlot = '${DateFormat('yyyy-MM-dd').format(_currentDay)} ${timings[index]}';
                final isBooked = bookedSlots.contains(currentTimeSlot);
                final timingDateTime = DateTime(
                  _currentDay.year,
                  _currentDay.month,
                  _currentDay.day,
                  int.parse(timingString.split(':')[0]),
                  int.parse(timingString.split(':')[1]),
                );
                final isTimingWithinShift = isWithinShift(timingDateTime);

                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: !isBooked && isTimingWithinShift
                      ? () {
                    setState(() {
                      _currentIndex = index;
                      _timeSelected = true;
                    });
                  }
                      : (!isTimingWithinShift || isBooked)
                      ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(isBooked ? 'Slot Already Booked' : 'Slot Outside Working Hours'),
                          content: Text(isBooked
                              ? 'Please select a different time slot.'
                              : 'Please select a time slot within the working hours.'),
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
                      : null,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index ? Colors.white : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                          ? Colors.green
                          : !isTimingWithinShift || isBooked
                          ? Colors.grey
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      timingString,
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
            ),
          ),
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
                      Navigator.pop(context, {'date': formattedDate, 'time': formattedTime});
                    }
                  }
                },
                text: 'Reschedule',
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
