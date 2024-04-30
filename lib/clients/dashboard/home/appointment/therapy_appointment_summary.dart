import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/add_more_therapy.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_success.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

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
    required this.selecteddateslots, required this.branchName, required this.childname, required this.therapistName, required this.therapyName,
  }) : super(key: key);

  @override
  State<TherapyAppointmentSummary> createState() => _TherapyAppointmentSummaryState();
}

class _TherapyAppointmentSummaryState extends State<TherapyAppointmentSummary> {
  int? selectedWeeks; // Default selected weeks

  List<Map<String, List<String>>> newDatesSlots = [];

  // Change the type here
  List<Map<String, List<String>>> calculateNewDatesAndSlots(int weeks, Map<String, List<List<String>>> selectedDatesSlots) {
    List<Map<String, List<String>>> newDatesSlots = [];

    // Calculate new dates with a 7-day gap for the specified number of weeks
    for (int i = 1; i <= weeks; i++) {
      selectedDatesSlots.forEach((date, timeSlotsWithCost) {
        // Parse the date string to a DateTime object
        DateTime originalDate = DateTime.parse(date);

        // Add 7 days for each week
        DateTime newDate = originalDate.add(Duration(days: i * 7));

        // Format the new date
        String formattedNewDate = DateFormat('yyyy-MM-dd').format(newDate);

        // Flatten the list of time slots with costs into a single list of strings
        List<String> flattenedTimeSlotsWithCost = timeSlotsWithCost.expand((timeSlot) => timeSlot).toList();

        // Add the new date with the flattened time slots and costs to newDatesSlots
        newDatesSlots.add({
          formattedNewDate: flattenedTimeSlotsWithCost,
        });
      });
    }

    return newDatesSlots;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.selecteddateslots);
    print(newDatesSlots);
    return Scaffold(
      appBar: customAppBar(title: 'Book Appointment'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Details:',
                    style: kTextStyle1,
                  ),
                  CustomButton(
                    text: 'Add Therapy',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddTherapy(branchId: widget.branchId, parentId: widget.parentId, childId: widget.childId,)));
                    },
                  )
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Branch : ${widget.branchName}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Child Name: ${widget.childname}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Therapist : ${widget.therapistName}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Therapy : ${widget.therapyName}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        Row(
                          children: [
                            Text("Repeat every: "),
                            DropdownButton<int>(
                              value: selectedWeeks,
                              hint: Text('Please select the repetition'),
                              onChanged: (value) {
                                setState(() {
                                  selectedWeeks = value; // Update the selected weeks
                                  newDatesSlots = calculateNewDatesAndSlots(value!, widget.selecteddateslots); // Recalculate new dates and slots
                                });
                              },
                              items: [1,2,4, 8, 12].map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value weeks'),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Text(
                          'Selected Slots:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.selecteddateslots.entries.map((entry) {
                            String date = entry.key;
                            List<List<String>> timeSlotsWithCost = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: $date', style: TextStyle(fontSize: 18)),
                                ...timeSlotsWithCost.map((slotWithCost) {
                                  String time = slotWithCost[0];
                                  String cost = slotWithCost[1];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Time: $time', style: TextStyle(fontSize: 16)),
                                      Text('Cost: $cost', style: TextStyle(fontSize: 16)),
                                    ],
                                  );
                                }).toList(),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        ),
                        if (newDatesSlots.isNotEmpty) // Show newly generated dates if available
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: newDatesSlots.map((entry) {
                                  String date = entry.keys.first;
                                  List<String> timeAndCost = entry.values.first;
                                  String time = timeAndCost[0];
                                  String cost = timeAndCost[1];

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Date: $date', style: TextStyle(fontSize: 18)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Time: $time', style: TextStyle(fontSize: 16)),
                                          Text('Cost: $cost', style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 10),
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
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: 'Next',
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
                        List<List<String>> formattedTimeSlots = timeSlots.map((slotWithCost) {
                          return [slotWithCost[0], slotWithCost[1].toString()];
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
                      await TherapistApi().bookAppointmentApi(bookingData);

                      // Check if the appointment booking was successful
                      if (response['status'] == 1) {
                        // If successful, navigate to the PaymentModes screen
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SuccessfulPayment(),
                        ));
                      } else {
                        // If booking failed, display an error message
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
                          print(e);
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Failed to book appointment. Error: $e'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}


