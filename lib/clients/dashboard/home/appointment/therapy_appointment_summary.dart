import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/add_more_therapy.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/therapy_appointment_rescheduling.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';

import '../payment/payment_summary.dart';

class TherapyAppointmentSummary extends StatefulWidget {
  final Map<String, List<List<String>>> selecteddateslots;
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String branchName;
  final String childname;
  final String therapistName;
  final String therapyName;

  const TherapyAppointmentSummary({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.therapistId,
    required this.therapyId,
    required this.selecteddateslots,
    required this.branchName,
    required this.childname,
    required this.therapistName,
    required this.therapyName,
  }) : super(key: key);

  @override
  State<TherapyAppointmentSummary> createState() =>
      _TherapyAppointmentSummaryState();
}

class _TherapyAppointmentSummaryState extends State<TherapyAppointmentSummary> {
  List<Map<String, dynamic>> summaryData = [];
  Map<int, int?> selectedWeeksMap = {}; // Map to store selected weeks for each therapy
  List<Map<String, List<String>>> newDatesSlots = [];
  List<String> bookedDates = [];

  bool isDateBooked(String date, String time) {
    return bookedDates.contains('$date $time');
  }

  void updateBookedDates(List<String> newBookedDates) {
    setState(() {
      bookedDates = newBookedDates;
    });
  }

  List<Map<String, List<String>>> calculateNewDatesAndSlots(
      int weeks, Map<String, List<List<String>>> selectedDatesSlots) {
    List<Map<String, List<String>>> newDatesSlots = [];

    // Calculate new dates with a 7-day gap for the specified number of weeks
    for (int i = 1; i <= weeks - 1; i++) {
      selectedDatesSlots.forEach((date, timeSlotsWithCost) {
        // Parse the date string to a DateTime object
        DateTime originalDate = DateTime.parse(date);

        // Add 7 days for each week
        DateTime newDate = originalDate.add(Duration(days: i * 7));

        // Format the new date
        String formattedNewDate = DateFormat('yyyy-MM-dd').format(newDate);

        // Flatten the list of time slots with costs into a single list of strings
        List<String> flattenedTimeSlotsWithCost =
        timeSlotsWithCost.expand((timeSlot) => timeSlot).toList();

        // Add the new date with the flattened time slots and costs to newDatesSlots
        newDatesSlots.add({
          formattedNewDate: flattenedTimeSlotsWithCost,
        });
      });
    }

    return newDatesSlots;
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
    String day = DateFormat('EEEE').format(dateTime); // Get the day of the week
    String formattedDate =
    DateFormat('dd-MMM-yy').format(dateTime); // Get the formatted date
    return '$formattedDate ($day)'; // Return formatted date along with the day
  }

  @override
  void initState() {
    super.initState();
    summaryData.add({
      'therapist_id': widget.therapistId,
      'therapist_name': widget.therapistName,
      'therapy_id': widget.therapyId,
      'therapyName': widget.therapyName,
      'formatted_dates': widget.selecteddateslots
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Booking Details'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white70,
                      border: Border(
                        top: BorderSide(
                          color: Colors.green.shade700,
                          width: 4.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Branch : ${widget.branchName}',
                            style: TextStyle(
                              fontSize: 16, // Example font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Child Name: ${widget.childname}',
                            style: TextStyle(
                              fontSize: 16, // Example font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: summaryData.map((data) {
                  int therapyIndex = summaryData.indexOf(data);
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white70,
                          border: Border(
                            top: BorderSide(
                              color: Colors.green.shade700,
                              width: 4.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Therapist : ${data['therapist_name']}',
                                style: TextStyle(
                                  fontSize: 16, // Example font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Therapy : ${data['therapyName']}',
                                style: TextStyle(
                                  fontSize: 16, // Example font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Repeat every:",
                                    style: TextStyle(
                                      fontSize: 16, // Example font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DropdownButton<int>(
                                    value: selectedWeeksMap[therapyIndex],
                                    hint: Text(
                                      'Choose',
                                      style: TextStyle(
                                        fontSize: 16, // Example font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedWeeksMap[therapyIndex] = value; // Update the selected weeks for the specific therapy
                                        newDatesSlots = calculateNewDatesAndSlots(
                                            value!,
                                            data['formatted_dates']); // Recalculate new dates and slots
                                        data['new_dates_slots'] = newDatesSlots; // Update the new dates for the specific therapy
                                      });
                                    },
                                    items: [
                                      4,
                                      8,
                                      12
                                    ].map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text('$value weeks'),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              const Text(
                                'Selected Slots:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: data['formatted_dates']
                                    .entries
                                    .map<Widget>((entry) {
                                  String date = entry.key;
                                  List<List<String>> timeSlotsWithCost =
                                      entry.value;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...timeSlotsWithCost
                                          .map<Widget>((slotWithCost) {
                                        String time = slotWithCost[0];
                                        String cost = slotWithCost[1];
                                        int slotIndex = timeSlotsWithCost.indexOf(slotWithCost);
                                        bool isBooked =
                                        isDateBooked(date, time);
                                        return Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: isBooked
                                                      ? Colors.red
                                                      : Colors.green.shade700),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Delete Slot'),
                                                      content: const Text(
                                                          'Do you want to delete the slot?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            // Delete the selected slot
                                                            setState(() {
                                                              summaryData[therapyIndex]['formatted_dates'][entry.key]?.removeAt(slotIndex);
                                                              // If no slots are left for the date, remove the date entry
                                                              if (summaryData[therapyIndex]['formatted_dates'][entry.key]?.isEmpty ?? false) {
                                                                summaryData[therapyIndex]['formatted_dates'].remove(entry.key);
                                                              }
                                                            });

                                                            // Call the API to remove buffer
                                                            Map<String,
                                                                dynamic>
                                                            bookingData = {
                                                              "prag_branch":
                                                              widget
                                                                  .branchId,
                                                              "prag_therapy":
                                                              widget
                                                                  .therapyId,
                                                              "prag_therapiest":
                                                              widget
                                                                  .therapistId,
                                                              "prag_parent":
                                                              widget
                                                                  .parentId,
                                                              "prag_child":
                                                              widget
                                                                  .childId,
                                                              "prag_bookingdatetime":
                                                              "",
                                                              "prag_addcall": 0,
                                                              "prag_removedatetime":
                                                              date +
                                                                  " " +
                                                                  time,
                                                              "prag_removecall":
                                                              1
                                                            };
                                                            Parent()
                                                                .removeBufferApi(
                                                                bookingData)
                                                                .then(
                                                                    (response) {
                                                                  print(response);
                                                                });
                                                            Navigator.of(
                                                                context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child:
                                                          Text('Delete'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            // Navigate to the RescheduleAppointment page
                                                            Navigator.pop(
                                                                context);
                                                            var result =
                                                            await Navigator
                                                                .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                    RescheduleAppointment(
                                                                      branchId: widget
                                                                          .branchId,
                                                                      parentId: widget
                                                                          .parentId,
                                                                      childId: widget
                                                                          .childId,
                                                                      therapistId: widget
                                                                          .therapistId,
                                                                      therapyId: widget
                                                                          .therapyId,
                                                                    ),
                                                              ),
                                                            );

                                                            // Handle the returned data
                                                            if (result !=
                                                                null &&
                                                                result
                                                                is Map) {
                                                              // Update the selected date and time in summaryData
                                                              setState(() {
                                                                String newDate =
                                                                result[
                                                                'date'];
                                                                String newTime =
                                                                result[
                                                                'time'];

                                                                String oldDate =
                                                                    date;
                                                                List<List<String>>
                                                                oldSlots =
                                                                    summaryData[therapyIndex]['formatted_dates'][
                                                                    oldDate] ??
                                                                        [];

                                                                // Remove the rescheduled slot from the old date
                                                                oldSlots.removeAt(slotIndex);
                                                                if (oldSlots
                                                                    .isEmpty) {
                                                                  summaryData[therapyIndex]['formatted_dates']
                                                                      .remove(
                                                                      oldDate);
                                                                } else {
                                                                  summaryData[therapyIndex]['formatted_dates'][
                                                                  oldDate] =
                                                                      oldSlots;
                                                                }

                                                                // Add the rescheduled slot to the new date
                                                                if (summaryData[therapyIndex]['formatted_dates']
                                                                    .containsKey(
                                                                    newDate)) {
                                                                  summaryData[therapyIndex]['formatted_dates'][
                                                                  newDate]!
                                                                      .add([
                                                                    newTime,
                                                                    slotWithCost[
                                                                    1]
                                                                  ]);
                                                                } else {
                                                                  summaryData[therapyIndex]['formatted_dates'][
                                                                  newDate] = [
                                                                    [
                                                                      newTime,
                                                                      slotWithCost[
                                                                      1]
                                                                    ]
                                                                  ];
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Text(
                                                              'Reschedule'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            Text(
                                              '${formatDate(date)} $time  ₹$cost',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: isBooked
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }).toList(),
                              ),
                              if (data['new_dates_slots'] != null &&
                                  data['new_dates_slots']
                                      .isNotEmpty) // Show newly generated dates if available
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'New Slots:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: data['new_dates_slots']
                                          .map<Widget>((entry) {
                                        String date = entry.keys.first;
                                        List<String> timeAndCost =
                                            entry.values.first;
                                        return Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            ...List.generate(
                                              timeAndCost.length ~/ 2,
                                                  (index) {
                                                String time =
                                                timeAndCost[index * 2];
                                                String cost = timeAndCost[
                                                index * 2 + 1];
                                                return Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.delete,
                                                          color: Colors.green
                                                              .shade700),
                                                      onPressed: () {
                                                        // Show an alert dialog with options to delete or reschedule the slot
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Delete Slot'),
                                                              content: Text(
                                                                  'Do you want to delete the slot?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // Delete the selected new slot
                                                                    setState(
                                                                            () {
                                                                          timeAndCost
                                                                              .removeAt(
                                                                              index * 2);
                                                                          timeAndCost
                                                                              .removeAt(
                                                                              index * 2);
                                                                          if (timeAndCost
                                                                              .isEmpty) {
                                                                            data[
                                                                            'new_dates_slots']
                                                                              ..remove(
                                                                                  entry);
                                                                          }
                                                                        });
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop(); // Close the dialog
                                                                  },
                                                                  child: Text(
                                                                      'Delete'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // Navigate to the RescheduleAppointment page
                                                                    Navigator.pop(
                                                                        context);
                                                                    var result = await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              RescheduleAppointment(
                                                                                branchId:
                                                                                widget.branchId,
                                                                                parentId:
                                                                                widget.parentId,
                                                                                childId:
                                                                                widget.childId,
                                                                                therapistId:
                                                                                widget.therapistId,
                                                                                therapyId:
                                                                                widget.therapyId,
                                                                              ),
                                                                        ));
                                                                    // Handle the returned data
                                                                    if (result !=
                                                                        null &&
                                                                        result
                                                                        is Map) {
                                                                      // Update the selected date and time in newDatesSlots
                                                                      setState(
                                                                              () {
                                                                            String
                                                                            newDate =
                                                                            result['date'];
                                                                            String
                                                                            newTime =
                                                                            result['time'];

                                                                            // Remove the old entry
                                                                            data['new_dates_slots']
                                                                                .remove(entry);

                                                                            // Add the new entry with the updated date and time
                                                                            data['new_dates_slots']
                                                                                .add({
                                                                              newDate: [
                                                                                newTime,
                                                                                cost
                                                                              ]
                                                                            });
                                                                          });
                                                                      data['new_dates_slots']
                                                                          .sort();
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      'Reschedule'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    Text(
                                                      '${formatDate(date)} $time ₹$cost',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Add More Therapy',
                    onPressed: () async {
                      Map<String, dynamic> newdata = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTherapy(
                                branchName: widget.branchName,
                                branchId: widget.branchId,
                                parentId: widget.parentId,
                                childId: widget.childId,
                                therapistId: widget.therapistId,
                                childname: widget.childname,
                                therapyId: widget.therapyId,
                                therapistName: widget.therapistName,
                                therapyName: widget.therapyName,
                              )));
                      if (newdata.containsKey('therapist_name') &&
                          newdata.containsKey('therapyName') &&
                          newdata.containsKey('therapy_id') &&
                          newdata.containsKey('therapist_id') &&
                          newdata.containsKey('formatted_dates')) {
                        setState(() {
                          summaryData.add(newdata);
                          print(summaryData);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('No data added'),
                          duration: const Duration(seconds: 1),
                        ));
                      }
                    },
                  ),
                  CustomButton(
                    text: 'Proceed',
                    onPressed: () async {
                      try {
                        await callCheckParentScheduleApi(); // Call the API on Proceed
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'Failed to prepare booking data. Error: $e'),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> callCheckParentScheduleApi() async {
    try {
      Map<String, dynamic> bookingData = {
        "prag_parent": widget.parentId,
        "prag_transactionid": 1,
        "prag_transactiondiscount": 0,
        "prag_transactionamount": 0,
        "prag_booking": [],
      };

      for (var data in summaryData) {
        Map<String, List<List<String>>> formattedDates = Map.from(data['formatted_dates']);
        Map<String, List<List<String>>> bookingDates = {};

        formattedDates.forEach((date, timeSlots) {
          bookingDates[date] = timeSlots.map((slotWithCost) {
            return [
              slotWithCost[0],
              slotWithCost[1].toString(),
            ];
          }).toList();
        });

        bookingData["prag_booking"].add({
          'prag_branch': widget.branchId,
          'prag_therapy': data['therapy_id'],
          'prag_therapiest': data['therapist_id'],
          'prag_child': widget.childId,
          'prag_bookingdatetime': bookingDates,
        });

        // Add new_dates_slots to booking data if available
        if (data.containsKey('new_dates_slots')) {
          Map<String, List<List<String>>> newDatesMap = {};
          data['new_dates_slots'].forEach((entry) {
            String date = entry.keys.first;
            List<String> timeAndCost = entry.values.first;
            newDatesMap[date] = List.generate(
                timeAndCost.length ~/ 2,
                    (index) =>
                [timeAndCost[index * 2], timeAndCost[index * 2 + 1]]);
          });
          newDatesMap.forEach((date, slots) {
            if (bookingData["prag_booking"].last['prag_bookingdatetime']
                .containsKey(date)) {
              bookingData["prag_booking"]
                  .last['prag_bookingdatetime'][date]
                  .addAll(slots);
            } else {
              bookingData["prag_booking"].last['prag_bookingdatetime'][date] =
                  slots;
            }
          });
        }
      }

      print("booking data is $bookingData");

      // Call the API to check parent schedule date
      Map<String, dynamic> response =
      await Parent().checkParentScheduleApi(bookingData);

      if (response['status'] == 1) {
        // Navigate to the PaymentSummary screen and pass the bookingData
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PaymentSummary(
            branchName: widget.branchName,
            childName: widget.childname,
            bookingData: bookingData,
          ),
        ));
      } else if (response['status'] == -2) {
        // Show the message in an alert dialog
        setState(() {
          bookedDates = (response['bookeddate'] as List)
              .map((booking) => booking['prag_bookeddate'].toString())
              .toList();
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Booking Error'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      response['message'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Booked Dates:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    ...response['bookeddate'].map<Widget>((booking) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Date: ${booking['prag_bookeddate']}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    List<String> newBookedDates = response['bookeddate']
                        .map<String>(
                            (booking) => booking['prag_bookeddate'].toString())
                        .toList();
                    updateBookedDates(newBookedDates);
                    setState(() {});
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {});
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception('Failed to prepare booking data. Error: $e');
    }
  }
}
