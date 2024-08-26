import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/therapy_appointment_summary.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleAdditionalTherapy extends StatefulWidget {
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String branchName;
  final String childname;
  final String therapistName;
  final String therapyName;
  const ScheduleAdditionalTherapy({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.therapistId,
    required this.therapyId,
    required this.branchName,
    required this.childname,
    required this.therapistName,
    required this.therapyName,
  }) : super(key: key);

  @override
  State<ScheduleAdditionalTherapy> createState() => _ScheduleAdditionalTherapyState();
}

class _ScheduleAdditionalTherapyState extends State<ScheduleAdditionalTherapy> {
  bool _isLoading = false;
  DateTime today = DateTime.now();
  DateTime? selectedDate;
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

  final Map<DateTime, List<String>> selectedTimeSlots = {};
  List<String> AlreadybookedSlots = [];
  List<String> AlreadybookedSlotsbyParent = [];
  Map<DateTime, List<Map<String, String>>> selectedTimeSlotsWithCost = {};
  List<String> weekOffDays = [];
  List<DateTime> holidayList = [];
  List<DateTime> bufferSlots = [];

  List<String> timesMorning = [
    '09:30',
    '10:15',
  ];
  List<String> timesAfterNoon = [
    '14:00',
    '14:45',
    '15:30',
    '16:15',
    '17:00',
    '17:45'
  ];
  List<String> timesEvening = ['18:30', '19:15'];
  List<String> timesBeforenoon = ['11:00', '11:45', '12:30'];

  bool showSlotSelectionMessage = false;
  bool isFetchingData = false;

  @override
  void initState() {
    super.initState();
    selectedDate = _startOfWeek(today);
    DateTime startOfWeek = selectedDate!;
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    fetchTherapistAppointments(startOfWeek, endOfWeek);
    fetchParentAppointments(startOfWeek, endOfWeek);
    fetchBufferSlots();
  }

  Future<void> fetchTherapistAppointments(DateTime startOfWeek, DateTime endOfWeek) async {
    setState(() {
      isFetchingData = true;
    });
    final String apiUrl = 'https://dev.cdcconnect.in/apiservice/consultation/get_therapistconsolidated_info';

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

        if (this.mounted) {
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
                AlreadybookedSlots = therapistSchedule
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

  Future<void> fetchParentAppointments(DateTime startOfWeek, DateTime endOfWeek) async {
    setState(() {
      isFetchingData = true;
    });
    final String apiUrl = 'https://dev.cdcconnect.in/apiservice/consultation/get_parentAppoinment_dateview';
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
            if (ParentSchedule != null) {
              setState(() {
                AlreadybookedSlotsbyParent = ParentSchedule
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

  Future<void> fetchBufferSlots() async {
    final String apiUrl = 'https://dev.cdcconnect.in/apiservice/consultation/get_bufferingDatelist';

    final Map<String, dynamic> body = {
      "prag_parentid": widget.parentId,
      "prag_childid": widget.childId
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
          if (responseData['status'] == 1) {
            final List<dynamic> bufferSchedule = responseData['parent_schedule'];
            setState(() {
              bufferSlots = bufferSchedule
                  .map((slot) => DateTime.parse(slot['buffer_booking_date']))
                  .toList();
            });
          } else {
            print('Failed to fetch buffer slots: ${responseData['message']}');
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } else {
        print('User ID or User Token is null.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      selectedDate = _startOfWeek(focusedDay);
      today = focusedDay;
    });
    DateTime startOfWeek = selectedDate!.subtract(Duration(days: selectedDate!.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    fetchTherapistAppointments(startOfWeek, endOfWeek);
    fetchParentAppointments(startOfWeek, endOfWeek);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    if (day.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You cannot select a past date.'),
        ),
      );
    } else {
      setState(() {
        selectedDate = day;
        today = day;
        selectedTimeSlots.clear();
        selectedTimeSlotsWithCost.clear();
        showSlotSelectionMessage = true;
        DateTime startOfWeek = selectedDate!.subtract(Duration(days: selectedDate!.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        fetchTherapistAppointments(startOfWeek, endOfWeek);
        fetchParentAppointments(startOfWeek, endOfWeek);
      });
    }
  }

  List<DateTime> _getSelectedWeekDates(DateTime selectedDate) {
    DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  bool isWithinNextSevenDays(DateTime date) {
    if (selectedDate == null) return false;
    final nextSevenDays = List.generate(7, (index) => selectedDate!.add(Duration(days: index)));
    return nextSevenDays.contains(date);
  }

  bool isWeekOff(DateTime date) {
    return weekOffDays.contains(DateFormat('EEEE').format(date));
  }

  bool isHoliday(DateTime date) {
    return holidayList.contains(date);
  }

  bool isCurrentWeek(DateTime date) {
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  bool isCurrentWeekDay(DateTime day, DateTime focusedDay) {
    DateTime startOfWeek = _startOfWeek(focusedDay);
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return day.isAfter(startOfWeek.subtract(const Duration(days: 1))) && day.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  DateTime _startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Schedule Therapy',
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Information'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Row(
                            children: [
                              Container(color:  const Color(0XFF06D001), height: 20, width: 20),
                              kwidth10,
                              const Expanded(child: Text('slots selected by you.')),
                            ],
                          ),
                          kheight10,
                          Row(
                            children: [
                              Container(color: Colors.grey, height: 20, width: 20),
                              kwidth10,
                              const Text('slots are already booked.'),
                            ],
                          ),
                          kheight10,
                          Row(
                            children: [
                              Container(color: const Color(0XFFFF7D29), height: 20, width: 20),
                              kwidth10,
                              const Text('slots are already booked by you.'),
                            ],
                          ),
                          kheight10,
                          Row(
                            children: [
                              Container(color: const Color(0XFF373A40).withOpacity(0.7), height: 20, width: 20),
                              kwidth10,
                              const Expanded(child: Text('slots are unavailable due to week off or holiday.')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: TableCalendar(
                calendarFormat: CalendarFormat.week,
                calendarStyle: const CalendarStyle(
                  cellMargin: EdgeInsets.all(8),
                  isTodayHighlighted: false,
                  outsideDaysVisible: true,
                ),
                firstDay: DateTime.now(),
                focusedDay: today,
                lastDay: DateTime.utc(2029, 9, 1).add(const Duration(days: 7)),
                rowHeight: 38,
                weekendDays: const [DateTime.sunday],
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: kTextStyle1,
                ),
                availableGestures: AvailableGestures.none,
                onPageChanged: (focusedDay) => _onPageChanged(focusedDay),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    bool isCurrentWeekDay = _startOfWeek(today).isBefore(day) && _startOfWeek(today).add(Duration(days: 7)).isAfter(day);
                    return Container(
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrentWeekDay ? Colors.green.shade900 : (day.isBefore(DateTime.now()) ? Colors.grey : Colors.green.shade200),
                        border: Border.all(width: 1, color: Colors.green),
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    bool isCurrentWeekDay = _startOfWeek(today).isBefore(day) && _startOfWeek(today).add(Duration(days: 7)).isAfter(day);
                    return Container(
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrentWeekDay ? Colors.green.shade900 : (day.isBefore(DateTime.now()) ? Colors.grey : Colors.green.shade200),
                        border: Border.all(width: 1, color: Colors.green),
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: const Text(
                      'Morning Session',
                      style: kTextStyle1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: timesMorning.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return TimeSlot(
                            time: timesMorning[index],
                            selectedWeekDates: _getSelectedWeekDates(
                                selectedDate ?? DateTime.now()),
                            selectedTimeSlots: selectedTimeSlots,
                            selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                            alreadyBookedSlots: AlreadybookedSlots,
                            firstShiftStart:
                            firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftEnd:
                            firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftStart:
                            secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftEnd:
                            secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftStart:
                            thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftEnd:
                            thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftStart:
                            beforenoonShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftEnd:
                            beforenoonShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftCost: firstShiftCost.toString(),
                            secondShiftCost: secondShiftCost.toString(),
                            thirdShiftCost: thirdShiftCost.toString(),
                            beforenoonShiftCost: beforenoonShiftCost.toString(),
                            alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                            isWeekOff: isWeekOff,
                            isHoliday: isHoliday,
                            bufferSlots: bufferSlots,
                          );
                        },
                      ),
                    ],
                  ),
                  kheight10,
                  Center(
                    child: const Text(
                      'Beforenoon Session',
                      style: kTextStyle1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: timesBeforenoon.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return TimeSlot(
                            time: timesBeforenoon[index],
                            selectedWeekDates: _getSelectedWeekDates(
                                selectedDate ?? DateTime.now()),
                            selectedTimeSlots: selectedTimeSlots,
                            selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                            alreadyBookedSlots: AlreadybookedSlots,
                            firstShiftStart:
                            firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftEnd:
                            firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftStart:
                            secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftEnd:
                            secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftStart:
                            thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftEnd:
                            thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftStart:
                            beforenoonShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftEnd:
                            beforenoonShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftCost: firstShiftCost.toString(),
                            secondShiftCost: secondShiftCost.toString(),
                            thirdShiftCost: thirdShiftCost.toString(),
                            beforenoonShiftCost: beforenoonShiftCost.toString(),
                            alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                            isWeekOff: isWeekOff,
                            isHoliday: isHoliday,
                            bufferSlots: bufferSlots,
                          );
                        },
                      ),
                    ],
                  ),
                  kheight10,
                  Center(
                    child: const Text(
                      'Afternoon Session',
                      style: kTextStyle1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: timesAfterNoon.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return TimeSlot(
                            time: timesAfterNoon[index],
                            selectedWeekDates: _getSelectedWeekDates(
                                selectedDate ?? DateTime.now()),
                            selectedTimeSlots: selectedTimeSlots,
                            selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                            alreadyBookedSlots: AlreadybookedSlots,
                            firstShiftStart:
                            firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftEnd:
                            firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftStart:
                            secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftEnd:
                            secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftStart:
                            thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftEnd:
                            thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftStart:
                            beforenoonShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftEnd:
                            beforenoonShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftCost: firstShiftCost.toString(),
                            secondShiftCost: secondShiftCost.toString(),
                            thirdShiftCost: thirdShiftCost.toString(),
                            beforenoonShiftCost: beforenoonShiftCost.toString(),
                            alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                            isWeekOff: isWeekOff,
                            isHoliday: isHoliday,
                            bufferSlots: bufferSlots,
                          );
                        },
                      ),
                    ],
                  ),
                  kheight10,
                  Center(
                    child: const Text(
                      'Evening Session',
                      style: kTextStyle1,
                    ),
                  ),
                  kheight10,
                  Column(
                    children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: timesEvening.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return TimeSlot(
                            time: timesEvening[index],
                            selectedWeekDates: _getSelectedWeekDates(
                                selectedDate ?? DateTime.now()),
                            selectedTimeSlots: selectedTimeSlots,
                            selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                            alreadyBookedSlots: AlreadybookedSlots,
                            firstShiftStart:
                            firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftEnd:
                            firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftStart:
                            secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            secondShiftEnd:
                            secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftStart:
                            thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            thirdShiftEnd:
                            thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftStart:
                            beforenoonShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                            beforenoonShiftEnd:
                            beforenoonShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                            firstShiftCost: firstShiftCost.toString(),
                            secondShiftCost: secondShiftCost.toString(),
                            thirdShiftCost: thirdShiftCost.toString(),
                            beforenoonShiftCost: beforenoonShiftCost.toString(),
                            alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                            isWeekOff: isWeekOff,
                            isHoliday: isHoliday,
                            bufferSlots: bufferSlots,
                          );
                        },
                      ),
                    ],
                  ),
                  kheight10,
                  _isLoading
                      ? Loading()
                      : Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: CustomButton(
                      onPressed: () {
                        Map<String, List<List<String>>> formattedData = {};
                        selectedTimeSlotsWithCost.forEach((date, slots) {
                          String formattedDate =
                              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          formattedData[formattedDate] = slots
                              .map((slot) => [slot['time']!, slot['cost']!])
                              .toList();
                        });
                        if (formattedData.isNotEmpty) {
                          Navigator.pop(context, formattedData);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      text: 'Book Slots',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSlot extends StatefulWidget {
  final String time;
  final List<DateTime> selectedWeekDates;
  final Map<DateTime, List<String>> selectedTimeSlots;
  final Map<DateTime, List<Map<String, String>>> selectedTimeSlotsWithCost;
  final List<String> alreadyBookedSlots;
  final List<String> alreadyBookedSlotsbyParent;
  final TimeOfDay firstShiftStart;
  final TimeOfDay firstShiftEnd;
  final TimeOfDay secondShiftStart;
  final TimeOfDay secondShiftEnd;
  final TimeOfDay thirdShiftStart;
  final TimeOfDay thirdShiftEnd;
  final TimeOfDay beforenoonShiftStart;
  final TimeOfDay beforenoonShiftEnd;
  final String firstShiftCost;
  final String secondShiftCost;
  final String thirdShiftCost;
  final String beforenoonShiftCost;
  final Function(DateTime) isWeekOff;
  final Function(DateTime) isHoliday;
  final List<DateTime> bufferSlots;

  const TimeSlot({
    required this.time,
    required this.selectedWeekDates,
    required this.selectedTimeSlots,
    required this.selectedTimeSlotsWithCost,
    Key? key,
    required this.alreadyBookedSlots,
    required this.firstShiftStart,
    required this.firstShiftEnd,
    required this.secondShiftStart,
    required this.secondShiftEnd,
    required this.thirdShiftStart,
    required this.thirdShiftEnd,
    required this.beforenoonShiftStart,
    required this.beforenoonShiftEnd,
    required this.firstShiftCost,
    required this.secondShiftCost,
    required this.thirdShiftCost,
    required this.beforenoonShiftCost,
    required this.alreadyBookedSlotsbyParent,
    required this.isWeekOff,
    required this.isHoliday,
    required this.bufferSlots,
  }) : super(key: key);

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  bool isWithinShift(DateTime dateTime) {
    TimeOfDay slotTime = TimeOfDay(
      hour: int.parse(widget.time.split(':')[0]),
      minute: int.parse(widget.time.split(':')[1]),
    );

    if ((slotTime.hour > widget.firstShiftStart.hour ||
        (slotTime.hour == widget.firstShiftStart.hour &&
            slotTime.minute >= widget.firstShiftStart.minute)) &&
        (slotTime.hour < widget.firstShiftEnd.hour ||
            (slotTime.hour == widget.firstShiftEnd.hour &&
                slotTime.minute < widget.firstShiftEnd.minute))) {
      return true;
    } else if ((slotTime.hour > widget.secondShiftStart.hour ||
        (slotTime.hour == widget.secondShiftStart.hour &&
            slotTime.minute >= widget.secondShiftStart.minute)) &&
        (slotTime.hour < widget.secondShiftEnd.hour ||
            (slotTime.hour == widget.secondShiftEnd.hour &&
                slotTime.minute < widget.secondShiftEnd.minute))) {
      return true;
    } else if ((slotTime.hour > widget.thirdShiftStart.hour ||
        (slotTime.hour == widget.thirdShiftStart.hour &&
            slotTime.minute >= widget.thirdShiftStart.minute)) &&
        (slotTime.hour < widget.thirdShiftEnd.hour ||
            (slotTime.hour == widget.thirdShiftEnd.hour &&
                slotTime.minute < widget.thirdShiftEnd.minute))) {
      return true;
    } else if ((slotTime.hour > widget.beforenoonShiftStart.hour ||
        (slotTime.hour == widget.beforenoonShiftStart.hour &&
            slotTime.minute >= widget.beforenoonShiftStart.minute)) &&
        (slotTime.hour < widget.beforenoonShiftEnd.hour ||
            (slotTime.hour == widget.beforenoonShiftEnd.hour &&
                slotTime.minute < widget.beforenoonShiftEnd.minute))) {
      return true;
    }

    return false;
  }

  bool isPast(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.selectedWeekDates.map((dateValue) {
        final isSelected =
            widget.selectedTimeSlots[dateValue]?.contains(widget.time) ?? false;
        final isBooked = widget.alreadyBookedSlots.contains(
            '${dateValue.year}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')} ${widget.time}');
        final isBookedbyParent = widget.alreadyBookedSlotsbyParent.contains(
            '${dateValue.year}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')} ${widget.time}');
        final isWithinShifts = isWithinShift(dateValue);
        final isWeekOffDay = widget.isWeekOff(dateValue);
        final isHoliday = widget.isHoliday(dateValue);
        final isPastTime = isPast(DateTime(dateValue.year, dateValue.month, dateValue.day,
            int.parse(widget.time.split(':')[0]), int.parse(widget.time.split(':')[1])));
        final isBufferSlot = widget.bufferSlots.contains(
            DateTime(dateValue.year, dateValue.month, dateValue.day,
                int.parse(widget.time.split(':')[0]), int.parse(widget.time.split(':')[1])));

        return GestureDetector(
          onTap: () {
            final date = dateValue;
            if (isPastTime) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Slot Unavailable'),
                    content: Text('You cannot select a past time slot'),
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
            } else if (isBooked) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Slot Already Booked'),
                    content: Text('The slot is already booked.'),
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
            } else if (!isWithinShifts ||
                isBookedbyParent ||
                isWeekOffDay ||
                isHoliday ||
                isBufferSlot) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Slot Unavailable'),
                    content: Text('This slot is unavailable.'),
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
            } else {
              setState(() {
                if (isSelected) {
                  widget.selectedTimeSlots[date]?.remove(widget.time);
                  widget.selectedTimeSlotsWithCost[date]
                      ?.removeWhere((slot) => slot['time'] == widget.time);
                } else {
                  double cost = 0.0;
                  final selectedTime = TimeOfDay(
                    hour: int.parse(widget.time.split(':')[0]),
                    minute: int.parse(widget.time.split(':')[1]),
                  );

                  if ((widget.firstShiftStart.hour < selectedTime.hour ||
                      (widget.firstShiftStart.hour == selectedTime.hour &&
                          widget.firstShiftStart.minute <=
                              selectedTime.minute)) &&
                      (widget.firstShiftEnd.hour > selectedTime.hour ||
                          (widget.firstShiftEnd.hour == selectedTime.hour &&
                              widget.firstShiftEnd.minute >=
                                  selectedTime.minute))) {
                    cost = double.parse(widget.firstShiftCost);
                  } else if ((widget.secondShiftStart.hour < selectedTime.hour ||
                      (widget.secondShiftStart.hour == selectedTime.hour &&
                          widget.secondShiftStart.minute <=
                              selectedTime.minute)) &&
                      (widget.secondShiftEnd.hour > selectedTime.hour ||
                          (widget.secondShiftEnd.hour == selectedTime.hour &&
                              widget.secondShiftEnd.minute >=
                                  selectedTime.minute))) {
                    cost = double.parse(widget.secondShiftCost);
                  } else if ((widget.thirdShiftStart.hour < selectedTime.hour ||
                      (widget.thirdShiftStart.hour == selectedTime.hour &&
                          widget.thirdShiftStart.minute <=
                              selectedTime.minute)) &&
                      (widget.thirdShiftEnd.hour > selectedTime.hour ||
                          (widget.thirdShiftEnd.hour == selectedTime.hour &&
                              widget.thirdShiftEnd.minute >=
                                  selectedTime.minute))) {
                    cost = double.parse(widget.thirdShiftCost);
                  } else if ((widget.beforenoonShiftStart.hour < selectedTime.hour ||
                      (widget.beforenoonShiftStart.hour == selectedTime.hour &&
                          widget.beforenoonShiftStart.minute <=
                              selectedTime.minute)) &&
                      (widget.beforenoonShiftEnd.hour > selectedTime.hour ||
                          (widget.beforenoonShiftEnd.hour == selectedTime.hour &&
                              widget.beforenoonShiftEnd.minute >=
                                  selectedTime.minute))) {
                    cost = double.parse(widget.beforenoonShiftCost);
                  }

                  widget.selectedTimeSlots[date] = [
                    ...(widget.selectedTimeSlots[date] ?? []),
                    widget.time
                  ];
                  widget.selectedTimeSlotsWithCost[date] = [
                    ...(widget.selectedTimeSlotsWithCost[date] ?? []),
                    {'time': widget.time, 'cost': cost.toString()}
                  ];
                }
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: isPastTime
                  ? Colors.grey
                  : isBookedbyParent
                  ? const Color(0XFFFF7D29)
                  : isBooked
                  ? Colors.grey
                  : isSelected
                  ? const Color(0XFF06D001)
                  : isWeekOffDay || isHoliday
                  ? Color(0XFF373A40).withOpacity(0.7)
                  : isBufferSlot
                  ? Colors.grey // Change color to gray for buffer slots
                  : isWithinShifts
                  ? Colors.grey
                  : Colors.grey,),
              borderRadius: BorderRadius.circular(5),
              color: isPastTime
                  ? Colors.grey
                  : isBookedbyParent
                  ? const Color(0XFFFF7D29)
                  : isBooked
                  ? Colors.grey
                  : isSelected
                  ? const Color(0XFF06D001)
                  : isWeekOffDay || isHoliday
                  ? Color(0XFF373A40).withOpacity(0.7)
                  : isBufferSlot
                  ? Colors.grey // Change color to gray for buffer slots
                  : isWithinShifts
                  ? Colors.transparent
                  : Colors.grey,
            ),
            child: Text(
              widget.time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isPastTime
                    ? Colors.white
                    : isBookedbyParent
                    ? Colors.white
                    : isBooked
                    ? Colors.white
                    : isSelected
                    ? Colors.white
                    : isWeekOffDay || isHoliday
                    ? Colors.white
                    : isBufferSlot
                    ? Colors.white // White color for buffer slots
                    : isWithinShifts
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

