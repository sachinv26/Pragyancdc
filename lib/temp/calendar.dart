// import 'package:flutter/material.dart';
// import 'package:pragyan_cdc/constants/appbar.dart';
// import 'package:pragyan_cdc/constants/styles/styles.dart';
// import 'package:pragyan_cdc/clients/dashboard/home/appointment/book_appointment.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class ScheduleAppointment extends StatefulWidget {
//   const ScheduleAppointment({Key? key}) : super(key: key);
//
//   @override
//   State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
// }
//
// class _ScheduleAppointmentState extends State<ScheduleAppointment> {
//   DateTime today = DateTime.now();
//   DateTime? selectedDate;
//   List<String> timesMorning = ['09:30', '10:15', '11:00', '11:45', '12:30', '01:15'];
//   List<String> timesEvening = [
//     '01:15',
//     '02:00',
//     '02:45',
//     '03.30',
//     '04:15',
//     '05:00',
//     '05:45',
//     '06:30',
//     '07:15',
//     '08:00',
//   ];
//
//   void _onDaySelected(DateTime day, DateTime focusedDay) {
//     setState(() {
//       selectedDate = day;
//       today = day;
//     });
//   }
//
//   List<DateTime> _getSelectedWeekDates(DateTime selectedDate) {
//     List<DateTime> weekDates = [];
//     DateTime currentDay = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
//     int daysAdded = 0;
//     while (daysAdded < 6) {
//       if (currentDay.weekday != DateTime.sunday) {
//         weekDates.add(currentDay);
//         daysAdded++;
//       }
//       currentDay = currentDay.add(Duration(days: 1));
//     }
//     return weekDates;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(title: 'Schedule Therapy'),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 child: TableCalendar(
//                   calendarStyle: const CalendarStyle(cellMargin: EdgeInsets.all(8)),
//                   firstDay: DateTime.now(),
//                   focusedDay: today,
//                   lastDay: DateTime.utc(2029, 9, 1).add(const Duration(days: 7)),
//                   rowHeight: 38,
//                   weekendDays: const [DateTime.sunday],
//                   headerStyle: const HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                     titleTextStyle: kTextStyle1,
//                   ),
//                   availableGestures: AvailableGestures.all,
//                   onDaySelected: _onDaySelected,
//                   selectedDayPredicate: (day) => isSameDay(day, selectedDate ?? DateTime.now()),
//                   calendarBuilders: CalendarBuilders(
//                     defaultBuilder: (context, day, focusedDay) {
//                       if (selectedDate != null &&
//                           day.isAfter(selectedDate!.subtract(Duration(days: selectedDate!.weekday - 1))) &&
//                           day.isBefore(selectedDate!.add(Duration(days: 7 - selectedDate!.weekday)))) {
//                         if (day.weekday != DateTime.sunday) {
//                           return Container(
//                             margin: const EdgeInsets.all(4),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               border: Border.all(width: 1, color: Colors.green),
//                               shape: BoxShape.rectangle,
//                             ),
//                             child: Text(
//                               '${day.day}',
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           );
//                         }
//                       } else if (day.weekday == DateTime.sunday) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: const Color.fromARGB(255, 199, 135, 130),
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               day.day.toString(),
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         );
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ),
//               const Center(
//                 child: Text(
//                   'Appointment Timing',
//                   style: TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Morning Session',
//                 style: kTextStyle1,
//               ),
//               const SizedBox(height: 10),
//               HoursSlot(selectedWeekDates: _getSelectedWeekDates(selectedDate ?? DateTime.now())),
//               const SizedBox(height: 10),
//               Column(
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: timesMorning.length,
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const SizedBox(height: 10);
//                     },
//                     itemBuilder: (BuildContext context, int index) {
//                       return TimeSlot(time: timesMorning[index]);
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Afternoon Session',
//                 style: kTextStyle1,
//               ),
//               const SizedBox(height: 10),
//               Column(
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: timesEvening.length,
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const SizedBox(height: 10);
//                     },
//                     itemBuilder: (BuildContext context, int index) {
//                       if (index == 0 && selectedDate != null) {
//                         List<DateTime> selectedWeekDates = _getSelectedWeekDates(selectedDate!);
//                         return HoursSlot(selectedWeekDates: selectedWeekDates);
//                       } else {
//                         return TimeSlot(time: timesEvening[index]);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const BookAppointment(),
//                     ));
//                   },
//                   child: const Text('Book Appointment'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class HoursSlot extends StatelessWidget {
//   final List<DateTime> selectedWeekDates;
//
//   const HoursSlot({
//     required this.selectedWeekDates,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: selectedWeekDates.map((date) {
//         return Container(
//           padding: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.blue,
//           ),
//           child: Text(
//             '${date.month}/${date.day}',
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
//
// class TimeSlot extends StatefulWidget {
//   final String time;
//
//   const TimeSlot({
//     required this.time,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<TimeSlot> createState() => _TimeSlotState();
// }
//
// class _TimeSlotState extends State<TimeSlot> {
//   int selectedIndex = -1; // Default value is -1, indicating no selection
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(6, (index) {
//         bool isSelected = index == selectedIndex;
//
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               // Toggle selection on tap
//               selectedIndex = isSelected ? -1 : index;
//             });
//           },
//           child: Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(5),
//               color: isSelected ? Colors.green : Colors.transparent,
//             ),
//             child: Text(
//               widget.time,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold,
//                 color: isSelected ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
