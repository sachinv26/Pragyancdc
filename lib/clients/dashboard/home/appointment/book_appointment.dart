import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/booking_details.dart';
import 'package:intl/intl.dart';


class BookAppointment extends StatelessWidget {
  final DateTime selectedDate;
  final String chosenTiming;

  const BookAppointment({Key? key, required this.selectedDate, required this.chosenTiming}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String session;
    // Determine session based on chosen timing
    if (int.parse(chosenTiming.split(':')[0]) < 12) {
      session = 'Morning';
    } else if (int.parse(chosenTiming.split(':')[0]) >= 12 && int.parse(chosenTiming.split(':')[0]) < 17) {
      session = 'Afternoon';
    } else {
      session = 'Evening';
    }

    return Scaffold(
      appBar: customAppBar(title: 'Book Appointment'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Column(
          children: [
            Text(
              'Note Your Appointment Timing:',
              style: kTextStyle1,
            ),
            SizedBox(height: 20),
            PhysicalModel(
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today), // Calendar icon
                          SizedBox(width: 5), // Adjust spacing
                          Text(
                            '${DateFormat("d MMM''yyyy").format(selectedDate)}', // Display selected date here
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time), // Clock icon
                          SizedBox(width: 5), // Adjust spacing
                          Text(
                            chosenTiming, // Display chosen timing here
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.sunny), // Clock icon
                          SizedBox(width: 5), // Adjust spacing
                          Text(
                            session, // Display session (Morning/Afternoon/Evening) here
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            SizedBox(height: 30),
            CustomButton(text: 'Next',onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BookingDetails()));
            },)
          ],
        ),
      ),
    );
  }
}


