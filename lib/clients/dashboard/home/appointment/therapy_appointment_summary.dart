import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/add_more_therapy.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/therapy_appointment_rescheduling.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_success.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';

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
  int? selectedWeeks; // Default selected weeks

  List<Map<String, List<String>>> newDatesSlots = [];

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
      'therapist_name': widget.therapistName,
      'therapyName': widget.therapyName,
      'formatted_dates': widget.selecteddateslots
    });

    print(widget.selecteddateslots);
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
              SizedBox(height: 20),
              Column(
                children: summaryData.map((data) {
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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
                                  value: selectedWeeks,
                                  hint: Text(
                                    'Choose',
                                    style: TextStyle(
                                      fontSize: 16, // Example font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedWeeks =
                                          value; // Update the selected weeks
                                      newDatesSlots = calculateNewDatesAndSlots(value!, data['formatted_dates']); // Recalculate new dates and slots
                                    });
                                  },
                                  items: [4, 8, 12]
                                      .map<DropdownMenuItem<int>>((int value) {
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
                                      return Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.green.shade700),
                                            onPressed: () {
                                              // Show an alert dialog with options to delete or reschedule the slot
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
                                                            widget
                                                                .selecteddateslots
                                                                .remove(
                                                                    entry.key);
                                                          });
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: Text('Delete'),
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
                                                              builder: (context) =>
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
                                                          if (result != null &&
                                                              result is Map) {
                                                            // Update the selected date and time in widget.selecteddateslots
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
                                                                  widget.selecteddateslots[
                                                                          oldDate] ??
                                                                      [];

                                                              // Create a new entry with the updated time
                                                              List<List<String>>
                                                                  updatedSlots =
                                                                  [];
                                                              for (List<
                                                                      String> slot
                                                                  in oldSlots) {
                                                                if (slot.length ==
                                                                    2) {
                                                                  updatedSlots
                                                                      .add([
                                                                    newTime,
                                                                    slot[1]
                                                                  ]);
                                                                } else {
                                                                  updatedSlots
                                                                      .add(
                                                                          slot);
                                                                }
                                                              }

                                                              // Remove the entry with the old date
                                                              widget
                                                                  .selecteddateslots
                                                                  .remove(
                                                                      oldDate);

                                                              // Add the entry with the new date and updated time slots
                                                              widget.selecteddateslots[
                                                                      newDate] =
                                                                  updatedSlots;
                                                            });
                                                          }
                                                        },
                                                        child:
                                                            Text('Reschedule'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          Text('${formatDate(date)}  $time',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ),
                            if (newDatesSlots
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
                                    children:
                                        newDatesSlots.map<Widget>((entry) {
                                      String date = entry.keys.first;
                                      List<String> timeAndCost =
                                          entry.values.first;
                                      String time = timeAndCost[0];
                                      String cost = timeAndCost[1];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color:
                                                        Colors.green.shade700),
                                                onPressed: () {
                                                  // Show an alert dialog with options to delete or reschedule the slot
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Delete Slot'),
                                                        content: Text(
                                                            'Do you want to delete the slot?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              // Delete the selected new slot
                                                              setState(() {
                                                                newDatesSlots
                                                                    .remove(
                                                                        entry);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                            child:
                                                                Text('Delete'),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
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
                                                                    therapistId:
                                                                        widget
                                                                            .therapistId,
                                                                    therapyId:
                                                                        widget
                                                                            .therapyId,
                                                                  ),
                                                                ),
                                                              );

                                                              // Handle the returned data
                                                              if (result !=
                                                                      null &&
                                                                  result
                                                                      is Map) {
                                                                // Update the selected date and time in newDatesSlots
                                                                setState(() {
                                                                  String
                                                                      newDate =
                                                                      result[
                                                                          'date'];
                                                                  String
                                                                      newTime =
                                                                      result[
                                                                          'time'];

                                                                  // Remove the old entry
                                                                  newDatesSlots
                                                                      .remove(
                                                                          entry);

                                                                  // Add the new entry with the updated date and time
                                                                  newDatesSlots
                                                                      .add({
                                                                    newDate: [
                                                                      newTime,
                                                                      cost
                                                                    ]
                                                                  });
                                                                });
                                                                newDatesSlots
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
                                              Text('${formatDate(date)} ',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              Text('$time',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ],
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
                          newdata.containsKey('formatted_dates')) {
                        setState(() {
                          summaryData.add(newdata);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('no data added'),
                          duration: const Duration(seconds: 1),
                        ));
                      }
                    },
                  ),
                  CustomButton(
                    text: 'Proceed',
                    onPressed: () async {
                      try {
                        Map<String, dynamic> bookingData = {
                          "prag_parent": widget.parentId,
                          "prag_transactionid": 1,
                          "prag_transactiondiscount": 150,
                          "prag_transactionamount": 4800,
                          "prag_booking": [],
                        };
                        // Convert newDatesSlots to a map with the same structure as selecteddatesSlots
                        Map<String, List<List<String>>> newDatesMap = {};
                        newDatesSlots.forEach((dateSlot) {
                          dateSlot.forEach((date, timeSlots) {
                            newDatesMap[date] = [timeSlots];
                          });
                        });

                        widget.selecteddateslots.addAll(newDatesMap);
                        widget.selecteddateslots.forEach((date, timeSlots) {
                          List<List<String>> formattedTimeSlots =
                          timeSlots.map((slotWithCost) {
                            return [
                              slotWithCost[0],
                              slotWithCost[1].toString()
                            ];
                          }).toList();
                          bookingData["prag_booking"].add({
                            'prag_branch': widget.branchId,
                            'prag_therapy': widget.therapyId,
                            'prag_therapiest': widget.therapistId,
                            'prag_child': widget.childId,
                            'prag_bookingdatetime': {
                              date: formattedTimeSlots,
                            },
                          });
                        });

                        print(bookingData);

                        final Map<String, dynamic> response =
                            await TherapistApi()
                                .bookAppointmentApi(bookingData);

                        // Check if the appointment booking was successful
                        if (response['status'] == 1) {
                          // If successful, navigate to the PaymentModes screen
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SuccessfulPayment(),
                          ));
                        } else if (response['status'] == -2) {
                          // If some dates are already booked, show the booked date in the dialog
                          List<Map<String, dynamic>> bookedDates =
                              List<Map<String, dynamic>>.from(
                                  response['bookeddate']);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Booking Error'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(response['message']),
                                    SizedBox(height: 10),
                                    Text('Booked Dates:'),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: bookedDates.map((date) {
                                        return Text(
                                            '- ${date['prag_bookeddate']}');
                                      }).toList(),
                                    ),
                                  ],
                                ),
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
                          // If booking failed for some other reason, display an error message
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Booking Error'),
                                content: Text(response['message']),
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
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content:
                              Text('Failed to book appointment. Error: $e'),
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
}
