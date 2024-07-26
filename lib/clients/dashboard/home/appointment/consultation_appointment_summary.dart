import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/therapy_appointment_rescheduling.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';

import '../../../../api/parent_api.dart';
import '../payment/payment_summary.dart';

class ConsultationAppointmentSummary extends StatefulWidget {
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
  const ConsultationAppointmentSummary({
    super.key,
    required this.selecteddateslots,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.therapistId,
    required this.therapyId,
    required this.branchName,
    required this.childname,
    required this.therapistName,
    required this.therapyName,
  });

  @override
  State<ConsultationAppointmentSummary> createState() => _ConsultationAppointmentSummaryState();
}

class _ConsultationAppointmentSummaryState extends State<ConsultationAppointmentSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Booking Details'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 10),
                          Text(
                            'Therapist : ${widget.therapistName}',
                            style: TextStyle(
                              fontSize: 16, // Example font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Therapy : ${widget.therapyName}',
                            style: TextStyle(
                              fontSize: 16, // Example font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Selected Slots:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.selecteddateslots.entries.map((entry) {
                              String date = entry.key;
                              List<List<String>> timeSlotsWithCost = entry.value;
                              DateTime parsedDate = DateTime.parse(date);
                              String day = DateFormat('EEEE').format(parsedDate);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: timeSlotsWithCost.map((slotWithCost) {
                                  String time = slotWithCost[0];
                                  String cost = slotWithCost[1];
                                  return Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.green.shade700),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Reschedule Slot'),
                                                content: const Text('Do you want to reschedule the slot?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      var result = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => RescheduleAppointment(
                                                            branchId: widget.branchId,
                                                            parentId: widget.parentId,
                                                            childId: widget.childId,
                                                            therapistId: widget.therapistId,
                                                            therapyId: widget.therapyId,
                                                          ),
                                                        ),
                                                      );

                                                      if (result != null && result is Map) {
                                                        setState(() {
                                                          String newDate = result['date'];
                                                          String newTime = result['time'];
                                                          String newCost = result['cost']; // Get the new cost
                                                          String oldDate = date;
                                                          List<List<String>> oldSlots = widget.selecteddateslots[oldDate] ?? [];

                                                          List<List<String>> updatedSlots = [];
                                                          for (List<String> slot in oldSlots) {
                                                            if (slot[0] == time && slot[1] == cost) {
                                                              updatedSlots.add([newTime, newCost]);
                                                            } else {
                                                              updatedSlots.add(slot);
                                                            }
                                                          }

                                                          widget.selecteddateslots.remove(oldDate);
                                                          widget.selecteddateslots[newDate] = updatedSlots;
                                                        });
                                                      }
                                                    },
                                                    child: Text('Reschedule'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      Text(
                                        '${DateFormat('dd-MMM-yyyy').format(parsedDate)} ($day)  $time  ₹$cost',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: 'Proceed',
                  onPressed: () async {
                    try {
                      // Create a list of booking details
                      List<Map<String, dynamic>> bookingList = [];
                      widget.selecteddateslots.forEach((date, timeSlotsWithCost) {
                        bookingList.add({
                          'prag_branch': widget.branchId,
                          'prag_therapy': widget.therapyId,
                          'prag_therapiest': widget.therapistId,
                          'prag_child': widget.childId,
                          'prag_bookingdatetime': {
                            date: timeSlotsWithCost,
                          }
                        });
                      });

                      // Create booking data according to the API's expected format
                      Map<String, dynamic> bookingData = {
                        "prag_parent": widget.parentId.toString(),
                        "prag_transactionid": 1,
                        "prag_transactiondiscount": 150,
                        "prag_transactionamount": 4800,
                        "prag_booking": bookingList,
                      };

                      // Make the API call with the booking data
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
                                    ...response['bookeddate']
                                        .map<Widget>((booking) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        throw Exception(response['message']);
                      }
                    } catch (e) {
                      // If an error occurred during the API call, display an error message
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
