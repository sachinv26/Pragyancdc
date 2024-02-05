import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/book_appointment.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleAppointment extends StatefulWidget {
  const ScheduleAppointment({super.key});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  DateTime today = DateTime.now();
  List<String> timesMorning = ['09:30', '10:15', '11:00', '11:45', '12:30'];
  List<String> timesEvening = [
    '01:15',
    '02:00',
    '02:45',
    '03.30',
    '04:15',
    '05:00',
    '05:45',
    '06:00'
  ];
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Schedule'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Selected day = ${today.toString().split(" ")[0]}'),
              Container(
                // padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  calendarStyle:
                      const CalendarStyle(cellMargin: EdgeInsets.all(8)),
                  firstDay: DateTime.utc(2023, 9, 1),
                  focusedDay: today,
                  lastDay: DateTime.utc(2029, 9, 1),
                  rowHeight: 38,
                  weekendDays: const [DateTime.sunday],
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: kTextStyle1),
                  availableGestures: AvailableGestures.all,
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (day.weekday == DateTime.sunday) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 199, 135, 130)),
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
                          // color: Colors.yellow,
                          border: Border.all(width: 1, color: Colors.green),
                          shape: BoxShape.rectangle,
                        ),
                        child: Text(
                          '${date.day}',
                          // style: const TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Center(child: Text('Appointment Timing')),

              kheight10,
              const Text(
                'Morning Session',
                style: kTextStyle1,
              ),
              kheight10,
              const HoursSlot(),
              kheight10,
              Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: timesMorning.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                          height: 10); // Adjust the height as needed
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return TimeSlot(time: timesMorning[index]);
                    },
                  ),
                ],
              ),
              kheight10,

              const Text(
                'Afternoon Session',
                style: kTextStyle1,
              ),
              kheight10,
              const HoursSlot(),
              kheight10,
              Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: timesEvening.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                          height: 10); // Adjust the height as needed
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return TimeSlot(time: timesEvening[index]);
                    },
                  ),
                ],
              ),
              kheight10,
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BookAppointment()));
                    },
                    child: const Text('Book Appointment')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HoursSlot extends StatelessWidget {
  const HoursSlot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        return Container(
          // margin:
          //     const EdgeInsets.only(right: 8), // Add margin between containers
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          child: const Text(
            'Hours',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

class TimeSlot extends StatefulWidget {
  final String time;
  const TimeSlot({
    required this.time,
    super.key,
  });

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  int selectedIndex = -1; // Default value is -1, indicating no selection

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        bool isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              // Toggle selection on tap
              selectedIndex = isSelected ? -1 : index;
            });
          },
          child: Container(
            //  margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: isSelected ? Colors.green : Colors.transparent,
            ),
            child: Text(
              widget.time,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
