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
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  const RescheduleAppointment({
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
  late DateTime _currentDay;
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  bool _isLoading = false;
  DateTime? _selectedDate;
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
  List<String> bookedSlots = [];
  List<String> parentBookedSlots = [];
  List<DateTime> holidayList = [];
  List<String> weekOffDays = [];
  bool isFetchingData = false;

  TimeOfDay? firstShiftStart;
  TimeOfDay? firstShiftEnd;
  TimeOfDay? secondShiftStart;
  TimeOfDay? secondShiftEnd;
  TimeOfDay? thirdShiftStart;
  TimeOfDay? thirdShiftEnd;
  TimeOfDay? beforenoonShiftStart;
  TimeOfDay? beforenoonShiftEnd;

  String? firstShiftCost;
  String? secondShiftCost;
  String? thirdShiftCost;
  String? beforenoonShiftCost;

  @override
  void initState() {
    super.initState();
    _currentDay = DateTime.now();
    fetchTherapistAppointments(DateTime.now(), DateTime.now().add(Duration(days: 7)));
    fetchParentAppointments(DateTime.now(), DateTime.now().add(Duration(days: 7)));
  }

  Future<void> fetchTherapistAppointments(DateTime startOfWeek, DateTime endOfWeek) async {
    setState(() {
      isFetchingData = true;
    });
    final String apiUrl = 'https://app.cdcconnect.in/apiservice/consultation/get_therapistconsolidated_info';

    final Map<String, dynamic> body = {
      "prag_branch": widget.branchId,
      "prag_therapy": widget.therapyId,
      "prag_therapiest": widget.therapistId,
      "prag_fromdate": DateFormat('yyyy-MM-dd').format(startOfWeek),
      "prag_todate": DateFormat('yyyy-MM-dd').format(endOfWeek),
      "prag_dateorder": 1
    };

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom': "parent",
          'Content-Type': 'application/json',
        };

        final response = await http.post(
          Uri.parse(apiUrl),
          body: json.encode(body),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          List<dynamic>? therapistSchedule = responseData['therapist_schedule'];
          List<dynamic>? therapistDetail = responseData['therapist_detail'];
          List<dynamic>? holidays = responseData['holiday_list'];

          if (therapistDetail != null && therapistDetail.isNotEmpty) {
            final therapistWorkingHours = therapistDetail[0];
            firstShiftCost = therapistWorkingHours['first_interval_amount'];
            secondShiftCost = therapistWorkingHours['two_interval_amount'];
            thirdShiftCost = therapistWorkingHours['three_interval_amount'];
            beforenoonShiftCost = therapistWorkingHours['fourth_beforenoon_interval_amount'];

            setState(() {
              firstShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['first_start']));
              firstShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['first_end']));
              secondShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['two_start']));
              secondShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['two_end']));
              thirdShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['third_start']));
              thirdShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['third_end']));
              beforenoonShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['fourth_beforenoon_start']));
              beforenoonShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['fourth_beforenoon_end']));
              weekOffDays.add(therapistWorkingHours['week_off']);
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
          if (holidays != null) {
            setState(() {
              holidayList = holidays.map((holiday) => DateTime.parse(holiday['leave_date'])).toList();
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
        isFetchingData = false;
      });
    }
  }

  Future<void> fetchParentAppointments(DateTime startOfWeek, DateTime endOfWeek) async {
    setState(() {
      isFetchingData = true;
    });
    final String apiUrl = 'https://app.cdcconnect.in/apiservice/consultation/get_parentAppoinment_dateview';

    final Map<String, dynamic> body = {
      "prag_branch": "0",
      "prag_therapy": "0",
      "prag_therapiest": "0",
      "prag_child": "0",
      "prag_parent": widget.parentId,
      "prag_fromdate": DateFormat('yyyy-MM-dd').format(startOfWeek),
      "prag_todate": DateFormat('yyyy-MM-dd').format(endOfWeek),
      "prag_dateorder": 1,
      "prag_status": 1
    };

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom': "parent",
          'Content-Type': 'application/json',
        };

        final response = await http.post(
          Uri.parse(apiUrl),
          body: json.encode(body),
          headers: headers,
        );

        if (this.mounted) {
          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = json.decode(response.body);
            List<dynamic>? ParentSchedule = responseData['parent_schedule'];
            print(responseData);

            if (ParentSchedule != null) {
              setState(() {
                parentBookedSlots = ParentSchedule
                    .map((appointment) =>
                '${appointment['appointment_date']} ${appointment['appointment_time'].toString().substring(0, 5)}')
                    .toList();
              });
            }
          } else {
            print('Request failed with status: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (this.mounted) {
        setState(() {
          isFetchingData = false;
        });
      }
    }
  }

  bool isWithinShift(DateTime dateTime) {
    TimeOfDay slotTime = TimeOfDay.fromDateTime(dateTime);

    List<TimeOfDay?> shiftStartTimes = [
      firstShiftStart,
      secondShiftStart,
      thirdShiftStart,
      beforenoonShiftStart,
    ];
    List<TimeOfDay?> shiftEndTimes = [
      firstShiftEnd,
      secondShiftEnd,
      thirdShiftEnd,
      beforenoonShiftEnd,
    ];

    shiftStartTimes = shiftStartTimes.whereType<TimeOfDay>().toList();
    shiftEndTimes = shiftEndTimes.whereType<TimeOfDay>().toList();

    for (int i = 0; i < shiftStartTimes.length; i++) {
      TimeOfDay? startTime = shiftStartTimes[i];
      TimeOfDay? endTime = shiftEndTimes[i];

      if (startTime == null || endTime == null) {
        continue;
      }
      if ((slotTime.hour > startTime.hour ||
          (slotTime.hour == startTime.hour && slotTime.minute >= startTime.minute)) &&
          (slotTime.hour < endTime.hour ||
              (slotTime.hour == endTime.hour && slotTime.minute < endTime.minute))) {
        return true;
      }
    }
    return false;
  }

  String getCostForTiming(String timing) {
    final selectedTime = TimeOfDay(
      hour: int.parse(timing.split(':')[0]),
      minute: int.parse(timing.split(':')[1]),
    );

    if (firstShiftStart != null && firstShiftEnd != null && selectedTime.hour >= firstShiftStart!.hour && selectedTime.hour <= firstShiftEnd!.hour) {
      return firstShiftCost!;
    } else if (secondShiftStart != null && secondShiftEnd != null && selectedTime.hour >= secondShiftStart!.hour && selectedTime.hour <= secondShiftEnd!.hour) {
      return secondShiftCost!;
    } else if (thirdShiftStart != null && thirdShiftEnd != null && selectedTime.hour >= thirdShiftStart!.hour && selectedTime.hour <= thirdShiftEnd!.hour) {
      return thirdShiftCost!;
    } else if (beforenoonShiftStart != null && beforenoonShiftEnd != null && selectedTime.hour >= beforenoonShiftStart!.hour && selectedTime.hour <= beforenoonShiftEnd!.hour) {
      return beforenoonShiftCost!;
    } else {
      return '0'; // Default cost if no shift matches
    }
  }

  bool isHoliday(DateTime date) {
    return holidayList.contains(date);
  }

  bool isWeekOff(DateTime date) {
    return weekOffDays.contains(DateFormat('EEEE').format(date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Reschedule Appointment'),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _tableCalendar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  : SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final timingString = timings[index];
                    final currentTimeSlot =
                        '${DateFormat('yyyy-MM-dd').format(_currentDay)} ${timings[index]}';
                    final isBooked = bookedSlots.contains(currentTimeSlot);
                    final isParentBooked = parentBookedSlots.contains(currentTimeSlot);
                    final timingDateTime = DateTime(
                      _currentDay.year,
                      _currentDay.month,
                      _currentDay.day,
                      int.parse(timingString.split(':')[0]),
                      int.parse(timingString.split(':')[1]),
                    );
                    final isTimingWithinShift = isWithinShift(timingDateTime);
                    final isHolidaySlot = isHoliday(_currentDay);
                    final isWeekOffSlot = isWeekOff(_currentDay);

                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: !isBooked && isTimingWithinShift && !isHolidaySlot && !isWeekOffSlot
                          ? () {
                        setState(() {
                          _currentIndex = index;
                          _timeSelected = true;
                        });
                      }
                          : isBooked || isParentBooked || !isTimingWithinShift || isHolidaySlot || isWeekOffSlot
                          ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(isBooked
                                  ? 'Slot Already Booked'
                                  : isParentBooked
                                  ? 'Slot Already Booked by You'
                                  : !isTimingWithinShift
                                  ? 'Slot Outside Working Hours'
                                  : isHolidaySlot
                                  ? 'Holiday'
                                  : isWeekOffSlot
                                  ? 'Week Off'
                                  : 'Unavailable Slot'),
                              content: Text(isBooked
                                  ? 'Please select a different time slot.'
                                  : isParentBooked
                                  ? 'You have already booked this slot.'
                                  : !isTimingWithinShift
                                  ? 'Please select a time slot within the working hours.'
                                  : isHolidaySlot
                                  ? 'This day is a holiday.'
                                  : isWeekOffSlot
                                  ? 'This day is a week off.'
                                  : 'This slot is unavailable.'),
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
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: _currentIndex == index
                              ? Colors.green
                              : isParentBooked
                              ? Colors.orange
                              : isHolidaySlot || isWeekOffSlot
                              ? Colors.black
                              : !isTimingWithinShift || isBooked
                              ? Colors.grey
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timingString,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _currentIndex == index || isHolidaySlot || isWeekOffSlot ? Colors.white : null,
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
                  child: _isLoading? Loading(): CustomButton(
                    onPressed: () {
                      if (_dateSelected && _timeSelected) {
                        String chosenTiming = timings[_currentIndex!];
                        if (_selectedDate != null) {
                          String formattedDate =
                          DateFormat('yyyy-MM-dd').format(_selectedDate!);
                          String formattedTime = chosenTiming;
                          String cost = getCostForTiming(formattedTime);
                          Navigator.pop(context, {
                            'date': formattedDate,
                            'time': formattedTime,
                            'cost': cost,
                          });
                        }
                      }
                    },
                    text: 'Reschedule',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      daysOfWeekVisible: true,
      weekendDays: [DateTime.sunday],
      focusedDay: _currentDay,
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
          _dateSelected = true;
          _selectedDate = focusedDay;
          if (selectedDay.weekday == 7) {
            _timeSelected = false;
            _currentIndex = null;
          }
          fetchTherapistAppointments(selectedDay, selectedDay.add(Duration(days: 7)));
          fetchParentAppointments(selectedDay, selectedDay.add(Duration(days: 7)));
        });
      }),
      firstDay: DateTime.now(),
      lastDay: DateTime(2026, 12, 31),
    );
  }
}
