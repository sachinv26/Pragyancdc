import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/appointment_summary.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleTherapy extends StatefulWidget {
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyCost;
  const ScheduleTherapy({Key? key, required this.branchId, required this.parentId, required this.childId, required this.therapistId, required this.therapyId, required this.therapyCost}) : super(key: key);
  @override
  State<ScheduleTherapy> createState() => _ScheduleTherapyState();
}

class _ScheduleTherapyState extends State<ScheduleTherapy> {
  DateTime today = DateTime.now();
  Map<DateTime, String?> selectedTimeSlots = {};
  Map<String, List<String>> generateSelectedTimeSlotsData(Map<DateTime, String?> selectedTimeSlots) {
    Map<String, List<String>> selectedTimeSlotsData = {};
    selectedTimeSlots.forEach((date, time) {
      String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      if (selectedTimeSlotsData.containsKey(formattedDate)) {
        selectedTimeSlotsData[formattedDate]!.add(time!);
      } else {
        selectedTimeSlotsData[formattedDate] = [time!];
      }
    });
    return selectedTimeSlotsData;
  }

  DateTime? selectedDate;
  List<String> timesMorning = ['09:30', '10:15', '11:00', '11:45', '12:30'];
  List<String> timesAfterNoon = ['14:00', '14:45', '15.30', '16:15', '17:00', '17:45'];
  List<String> timesEvening = ['18:30', '19:15'];

  bool showSlotSelectionMessage = false;

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
        // Clear previously selected time slots
        selectedTimeSlots.clear();
        // Show slot selection message only when a day is selected
        showSlotSelectionMessage = true;
      });
    }
  }

  List<DateTime> _getSelectedWeekDates(DateTime selectedDate) {
    if (selectedDate == null)
      return []; // Return empty list if no week is selected

    List<DateTime> weekDates = [];
    DateTime currentDay =
    selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    int daysAdded = 0;
    while (daysAdded < 6) {
      if (currentDay.weekday != DateTime.sunday) {
        weekDates.add(currentDay);
        daysAdded++;
      }
      currentDay = currentDay.add(Duration(days: 1));
    }
    return weekDates;
  }

  bool isWithinNextSevenDays(DateTime date) {
    if (selectedDate == null) return false;
    final nextSevenDays = List.generate(7, (index) => selectedDate!.add(Duration(days: index)));
    return nextSevenDays.contains(date);
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
                      final isOutsideMonth = day.month != focusedDay.month;
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
              const SizedBox(height: 10),
              Center(
                child: const Text(
                  'Morning Session',
                  style: kTextStyle1,
                ),
              ),
              const SizedBox(height: 10),
              DaysSlot(selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now())),
              const SizedBox(height: 10),
              Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: timesMorning.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return TimeSlot(time: timesMorning[index],selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now()),selectedTimeSlots: selectedTimeSlots);
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
              DaysSlot(selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now())),
              const SizedBox(height: 10),
              Column(
                children: [
                  ListView.separated(
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
              DaysSlot(selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now())),
              const SizedBox(height: 10),
              Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: timesEvening.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return TimeSlot(time: timesEvening[index],selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now()),selectedTimeSlots: selectedTimeSlots,);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Map<String, List<String>> selectedTimeSlotsData = generateSelectedTimeSlotsData(selectedTimeSlots);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BookAppointment(
                        selecteddateslots: selectedTimeSlotsData,
                        branchId: widget.branchId,
                        parentId: widget.parentId,
                        childId: widget.childId,
                        therapistId: widget.therapistId,
                        therapyId: widget.therapyId,
                        therapyCost: widget.therapyCost,
                      ),
                    ));
                  },
                  child: const Text('Book Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DaysSlot extends StatefulWidget {
  final List<DateTime> selectedWeekDates;
  const DaysSlot({
    required this.selectedWeekDates,
    Key? key,
  }) : super(key: key);

  @override
  State<DaysSlot> createState() => _DaysSlotState();
}

class _DaysSlotState extends State<DaysSlot> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.selectedWeekDates.map((date) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          child: Text(
            '${date.month}/${date.day}',
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
  final List<DateTime> selectedWeekDates; // Dates for the week
  final Map<DateTime, String?> selectedTimeSlots; // Selected time slots for each date

  const TimeSlot({
    required this.time,
    required this.selectedWeekDates,
    required this.selectedTimeSlots,
    Key? key,
  }) : super(key: key);

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.selectedWeekDates.map((date) {
        final isSelected = widget.selectedTimeSlots[date] == widget.time;
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                // If the slot is already selected, deselect it
                widget.selectedTimeSlots.remove(date);
              } else {
                // Otherwise, select this slot for the selected date
                widget.selectedTimeSlots[date] = widget.time;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: isSelected ? Colors.green : Colors.transparent,
            ),
            child: Text(
              widget.time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}












