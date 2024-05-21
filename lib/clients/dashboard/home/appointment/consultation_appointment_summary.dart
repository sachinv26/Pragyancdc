import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/payment/payment_success.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';



class BookConsultation extends StatelessWidget {
  final Map<String, List<String>> selecteddateslots;
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyCost;
  final String branchName;
  final String childname;
  final String therapistName;
  final String therapyName;
  const BookConsultation({super.key, required this.selecteddateslots, required this.branchId, required this.parentId, required this.childId, required this.therapistId, required this.therapyId, required this.therapyCost, required this.branchName, required this.childname, required this.therapistName, required this.therapyName});

  @override
  Widget build(BuildContext context) {
    print(selecteddateslots);
    return Scaffold(
      appBar: customAppBar(
        title: 'Book Consulation'
      ),
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
                        Text('Branch : ${branchName}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Child Name: ${childname}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Therapist : ${therapistName}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Therapy : ${therapyName}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 10),
                        Text('Total Amount: ${therapyCost}', style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 20),
                        Text(
                          'Selected Slots:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selecteddateslots.entries.map((entry) {
                            String date = entry.key;
                            List<String> timeSlots = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Date: $date', style: TextStyle(fontSize: 18)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: timeSlots.map((time) {
                                        return Text('Time: $time', style: TextStyle(fontSize: 18));
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
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
                      // Create a list of booking details
                      List<Map<String, dynamic>> bookingList = [];
                      selecteddateslots.forEach((date, timeSlots) {
                        bookingList.add({
                          'prag_branch': branchId,
                          'prag_therapy': therapyId,
                          'prag_therapiest': therapistId,
                          'prag_child': childId,
                          'prag_bookingdatetime': {
                            date: [
                              [timeSlots[0].substring(0, 5), therapyCost.toString()] // Adjusted timeSlots format
                            ]
                          }
                        });
                      });

                      // Create booking data according to the API's expected format
                      Map<String, dynamic> bookingData = {
                        "prag_parent": parentId.toString(),
                        "prag_transactionid": 1,
                        "prag_transactiondiscount": 150,
                        "prag_transactionamount": 4800,
                        "prag_booking": bookingList,
                      };

                      print(bookingData);

                      // Make the API call with the booking data
                      final Map<String, dynamic> response = await TherapistApi().bookAppointmentApi(bookingData);

                      // Check if the appointment booking was successful
                      if (response['status'] == 1) {
                        // If successful, navigate to the PaymentModes screen
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                      // If an error occurred during the API call, display an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
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
