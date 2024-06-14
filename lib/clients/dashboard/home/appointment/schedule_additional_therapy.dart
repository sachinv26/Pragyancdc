import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/therapy_appointment_summary.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
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
  const ScheduleAdditionalTherapy(
      {Key? key,
        required this.branchId,
        required this.parentId,
        required this.childId,
        required this.therapistId,
        required this.therapyId,
        required this.branchName, required this.childname, required this.therapistName, required this.therapyName})
      : super(key: key);
  @override
  State<ScheduleAdditionalTherapy> createState() => _ScheduleAdditionalTherapyState();
}

class _ScheduleAdditionalTherapyState extends State<ScheduleAdditionalTherapy> {
  DateTime today = DateTime.now();
  DateTime? selectedDate;
  TimeOfDay? firstShiftStart;
  TimeOfDay? firstShiftEnd;
  TimeOfDay? secondShiftStart;
  TimeOfDay? secondShiftEnd;
  TimeOfDay? thirdShiftStart;
  TimeOfDay? thirdShiftEnd;

  String? firstShiftCost;
  String? secondShiftCost;
  String? thirdShiftCost;


  final Map<DateTime, List<String>> selectedTimeSlots = {};
  List<String> AlreadybookedSlots = [];
  List<String> AlreadybookedSlotsbyParent =[];
  Map<DateTime, List<Map<String, String>>> selectedTimeSlotsWithCost = {};


  List<String> timesMorning = ['09:00','09:30', '10:15', '11:00', '11:45', '12:30'];
  List<String> timesAfterNoon = [
    '14:00',
    '14:45',
    '15:30',
    '16:15',
    '17:00',
    '17:45'
  ];
  List<String> timesEvening = ['18:30', '19:15'];

  bool showSlotSelectionMessage = false;
  bool isFetchingData = false;

  @override
  void initState() {
    super.initState();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    fetchTherapistAppointments(startOfWeek, endOfWeek);
    fetchParentAppointments(startOfWeek, endOfWeek);
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
          'pragusercallfrom':"parent",
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

            if (therapistDetail != null && therapistDetail.isNotEmpty) {
              final therapistWorkingHours = therapistDetail[0];
              firstShiftCost= therapistWorkingHours['first_interval_amount'];
              secondShiftCost= therapistWorkingHours['two_interval_amount'];
              thirdShiftCost= therapistWorkingHours['three_interval_amount'];

              setState(() {
                firstShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['first_start']));
                firstShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['first_end']));
                secondShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['two_start']));
                secondShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['two_end']));
                thirdShiftStart = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['third_start']));
                thirdShiftEnd = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(therapistWorkingHours['third_end']));
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
    final String apiUrl = 'https://app.cdcconnect.in/apiservice/consultation/get_parentAppoinment_dateview';

    final Map<String, dynamic> body = {
      "prag_branch": "0",
      "prag_therapy": "0",
      "prag_therapiest": "0",
      "prag_child": "0",
      "prag_parent" : widget.parentId,
      "prag_fromdate": DateFormat('yyyy-MM-dd').format(startOfWeek),
      "prag_todate": DateFormat('yyyy-MM-dd').format(endOfWeek),
      "prag_dateorder": 1,
      "prag_status" :1
    };

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

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


  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      selectedDate = focusedDay.subtract(Duration(days: focusedDay.weekday - 1)); // Set selectedDate to the start of the visible week
      today = focusedDay;
    });
    DateTime startOfWeek = selectedDate!.subtract(Duration(days: selectedDate!.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 5));
    fetchTherapistAppointments(startOfWeek, endOfWeek);
    fetchParentAppointments(startOfWeek, endOfWeek);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    if (day.weekday == DateTime.sunday) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking not allowed on Sundays'),
          duration: const Duration(seconds: 1),
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
    List<DateTime> weekDates = [];
    DateTime currentDay = selectedDate;

    // If today is Sunday, start from Monday
    if (currentDay.weekday == DateTime.sunday) {
      currentDay = currentDay.add(Duration(days: 1));
    }

    // Adjust current day to the start of the week (Monday)
    while (currentDay.weekday != DateTime.monday) {
      currentDay = currentDay.subtract(Duration(days: 1));
    }

    // Add dates for the current week
    for (int i = 0; i < 6; i++) {
      weekDates.add(currentDay.add(Duration(days: i)));
    }

    return weekDates;
  }


  bool isWithinNextSevenDays(DateTime date) {
    if (selectedDate == null) return false;
    final nextSevenDays =
    List.generate(7, (index) => selectedDate!.add(Duration(days: index)));
    return nextSevenDays.contains(date);
  }

  void navigateToNextScreen(
      BuildContext context, {
        required Map<String, List<List<String>>> formattedData,
        required String branchId,
        required String parentId,
        required String childId,
        required String therapistId,
        required String therapyId,
        required String branchName,
        required String childname,
        required String therapistName,
        required String therapyName,
      }) {
    Navigator.of(context).pushNamed(
      '/summaryscreen',
      arguments: {
        'formattedData': formattedData,
        'branchId': branchId,
        'parentId': parentId,
        'childId': childId,
        'therapistId': therapistId,
        'therapyId': therapyId,
        'branchName': branchName,
        'childname': childname,
        'therapistName': therapistName,
        'therapyName': therapyName,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Schedule Therapy'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: SingleChildScrollView(
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
                  lastDay:
                  DateTime.utc(2029, 9, 1).add(const Duration(days: 7)),
                  rowHeight: 38,
                  weekendDays: const [DateTime.sunday],
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: kTextStyle1,
                  ),
                  availableGestures: AvailableGestures.all,
                  onDaySelected: (day, focusedDay) =>
                      _onDaySelected(day, focusedDay),
                  onPageChanged: (focusedDay) => _onPageChanged(focusedDay),
                  selectedDayPredicate: (day) =>
                      isSameDay(day, selectedDate ?? DateTime.now()),
                  calendarBuilders: CalendarBuilders(
                    outsideBuilder: (context, day, _) {
                      if (isWithinNextSevenDays(day)) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(width: 1, color: Colors.green),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          // Customize the styling for outside month dates here
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      // final isOutsideMonth = day.month != focusedDay.month;
                      if (selectedDate != null &&
                          day.isAfter(selectedDate!.subtract(
                              Duration(days: selectedDate!.weekday - 1))) &&
                          day.isBefore(selectedDate!.add(
                              Duration(days: 7 - selectedDate!.weekday)))) {
                        if (day.weekday != DateTime.sunday) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(width: 1, color: Colors.green),
                              shape: BoxShape
                                  .rectangle, // Changed shape to rectangle
                            ),
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }
                      } else if (day.weekday == DateTime.sunday) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 199, 135, 130),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Center(
                child: const Text(
                  'Morning Session',
                  style: kTextStyle1,
                ),
              ),
              const SizedBox(height: 10),
              DaysSlot(
                  selectedWeekDates:
                  _getSelectedWeekDates(selectedDate ?? DateTime.now())),
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
                        selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now()),
                        selectedTimeSlots: selectedTimeSlots,
                        selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                        alreadyBookedSlots: AlreadybookedSlots,
                        firstShiftStart: firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        firstShiftEnd: firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        secondShiftStart: secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        secondShiftEnd: secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        thirdShiftStart: thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        thirdShiftEnd: thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        firstShiftCost:  firstShiftCost.toString(),
                        secondShiftCost: secondShiftCost.toString(),
                        thirdShiftCost: thirdShiftCost.toString(),
                        alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                      );
                    },
                  ),
                ],
              ),
              Center(
                child: const Text(
                  'Afternoon Session',
                  style: kTextStyle1,
                ),
              ),
              const SizedBox(height: 10),
              DaysSlot(
                  selectedWeekDates:
                  _getSelectedWeekDates(selectedDate ?? DateTime.now())),
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
                        selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now()),
                        selectedTimeSlots: selectedTimeSlots,
                        selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                        alreadyBookedSlots: AlreadybookedSlots,
                        firstShiftStart: firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        firstShiftEnd: firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        secondShiftStart: secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        secondShiftEnd: secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        thirdShiftStart: thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        thirdShiftEnd: thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        firstShiftCost:  firstShiftCost.toString(),
                        secondShiftCost: secondShiftCost.toString(),
                        thirdShiftCost: thirdShiftCost.toString(),
                        alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                      );
                    },
                  ),
                ],
              ),
              Center(
                child: const Text(
                  'Evening Session',
                  style: kTextStyle1,
                ),
              ),
              const SizedBox(height: 10),
              DaysSlot(
                  selectedWeekDates:
                  _getSelectedWeekDates(selectedDate ?? DateTime.now())),
              const SizedBox(height: 10),
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
                        selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now()),
                        selectedTimeSlots: selectedTimeSlots,
                        selectedTimeSlotsWithCost: selectedTimeSlotsWithCost,
                        alreadyBookedSlots: AlreadybookedSlots,
                        firstShiftStart: firstShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        firstShiftEnd: firstShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        secondShiftStart: secondShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        secondShiftEnd: secondShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        thirdShiftStart: thirdShiftStart ?? TimeOfDay(hour: 0, minute: 0),
                        thirdShiftEnd: thirdShiftEnd ?? TimeOfDay(hour: 0, minute: 0),
                        firstShiftCost:  firstShiftCost.toString(),
                        secondShiftCost: secondShiftCost.toString(),
                        thirdShiftCost: thirdShiftCost.toString(),
                        alreadyBookedSlotsbyParent: AlreadybookedSlotsbyParent,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
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
                    if(formattedData.isNotEmpty){
                      Navigator.pop(context,formattedData);
                    }
                    else{
                      Navigator.pop(context);
                    }
                  },
                  text: 'Book Slots',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DaysSlot extends StatelessWidget {
  final List<DateTime> selectedWeekDates;
  const DaysSlot({
    required this.selectedWeekDates,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: selectedWeekDates.map((date) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          child: Text(
            '${date.day}/${date.month}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
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
  final String firstShiftCost;
  final String secondShiftCost;
  final String thirdShiftCost;


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
    required this.thirdShiftEnd, required this.firstShiftCost, required this.secondShiftCost, required this.thirdShiftCost, required this.alreadyBookedSlotsbyParent,
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
    }

    return false;
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

        return GestureDetector(
          onTap: isWithinShifts
              ? () {
            final date = dateValue;
            if (isBooked ) {
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
            } else {
              setState(() {
                if (isSelected) {
                  widget.selectedTimeSlots[date]?.remove(widget.time);
                  widget.selectedTimeSlotsWithCost[date]?.removeWhere(
                          (slot) => slot['time'] == widget.time);
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
                  } else if ((widget.secondShiftStart.hour <
                      selectedTime.hour ||
                      (widget.secondShiftStart.hour ==
                          selectedTime.hour &&
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
          }
              : null,
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: widget.alreadyBookedSlotsbyParent.contains(
                  '${dateValue.year}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')} ${widget.time}')
                  ? Colors.orange // Change color to blue for booked by parent
                  : widget.alreadyBookedSlots.contains(
                  '${dateValue.year}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')} ${widget.time}')
                  ? Colors.grey // Change color to grey for already booked
                  : isSelected
                  ? Colors.green
                  : isWithinShifts
                  ? Colors.transparent
                  : Colors.grey,
            ),
            child: Text(
              widget.time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: widget.alreadyBookedSlotsbyParent.contains(
                    '${dateValue.year}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')} ${widget.time}')
                    ? Colors.white
                    : widget.alreadyBookedSlots.contains(
                    '${dateValue.year}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')} ${widget.time}')
                    ? Colors.white // Change color to white for already booked
                    : isSelected
                    ? Colors.white
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
