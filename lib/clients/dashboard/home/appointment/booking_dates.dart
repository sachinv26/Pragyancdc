import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_modes.dart';
import 'package:pragyan_cdc/model/booking_details_model.dart';

class BookingDetails extends StatelessWidget {
  final Map<String, List<String>> selecteddateslots;
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyCost;

  const BookingDetails({
    Key? key,
    required this.branchId,
    required this.parentId,
    required this.childId,
    required this.therapistId,
    required this.therapyId,
    required this.therapyCost,
    required this.selecteddateslots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Book Appointment'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details:',
              style: kTextStyle1,
            ),
            SizedBox(height: 10),
            Text('Branch ID: $branchId', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Parent ID: $parentId', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Child ID: $childId', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Therapist ID: $therapistId', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Therapy ID: $therapyId', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Therapy Cost: $therapyCost', style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Text(
              'Selected Slots:',
              style: kTextStyle1,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selecteddateslots.length,
                itemBuilder: (context, index) {
                  final date = selecteddateslots.keys.elementAt(index);
                  final timeSlots = selecteddateslots[date];
                  return Column(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date: $date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: timeSlots!
                                        .map(
                                          (time) => Text(
                                        'Time: $time',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                        .toList(),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                    ],
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Next',
              onPressed: () async {
                try {
                  // Create a list of booking details
                  List<Map<String, dynamic>> bookingList = [];
                  selecteddateslots.forEach((date, timeSlots) {
                    bookingList.add({
                      'prag_branch': branchId,
                      'prag_therapy': therapyId,
                      'prag_therapiest': therapistId,
                      'prag_child': childId,
                      'prag_bookingdatetime': {
                        date: [timeSlots[0], therapyCost]
                      }
                    });
                  });

                  // Create an instance of BookingDetailsModel
                  BookingDetailsModel bookingDetails = BookingDetailsModel(
                    pragParent: parentId,
                    pragTransactionId: 1,
                    pragTransactionDiscount: 150,
                    pragTransactionAmount: 4800,
                    pragBooking: bookingList,
                  );

                  // Make the API call and await the response
                  final Map<String, dynamic> response =
                  await TherapistApi().bookAppointmentApi(bookingDetails);

                  // Check if the appointment booking was successful
                  if (response['status'] == 1) {
                    // If successful, navigate to the PaymentModes screen
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentModes(),
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
          ],
        ),
      ),
    );
  }
}
