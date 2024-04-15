import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/booking_dates.dart';

class BookAppointment extends StatelessWidget {
  final Map<String, List<String>> selecteddateslots;
  final String branchId;
  final String parentId;
  final String childId;
  final String therapistId;
  final String therapyId;
  final String therapyCost;

  const BookAppointment({
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                    ).toList(),
                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: CustomButton(
                text: 'Next',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BookingDetails(
                      selecteddateslots: selecteddateslots,
                      branchId: branchId,
                      parentId: parentId,
                      childId: childId,
                      therapistId: therapistId,
                      therapyId: therapyId,
                      therapyCost: therapyCost,
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
