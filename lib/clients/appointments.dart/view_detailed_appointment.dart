import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/parent_schedule_model.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final ParentSchedule appointment;

  const AppointmentDetailScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();


}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: 'Appointment Details'
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border(
                          top: BorderSide(
                            color: Colors.green.shade700,
                            width: 4.0,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Therapist Image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            kheight10,
                            CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                child: Image.network(
                                  "https://dev.cdcconnect.in/${widget.appointment.therapistImg}",
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                              .expectedTotalBytes !=
                                              null
                                              ? loadingProgress
                                              .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            kheight10,
            Card(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border(
                    top: BorderSide(
                      color: Colors.green.shade700,
                      width: 4.0,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Child Name: ${widget.appointment.childName}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                      Text(
                        'Location : ${widget.appointment.branchName}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                      Text(
                        'Therapy : ${widget.appointment.therapyName}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                      Text(
                        'Therapist: ${widget.appointment.therapistName}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                      Text(
                        'Appointment Date: ${widget.appointment.appointmentDate}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                      Text(
                        'Appointment Time: ${widget.appointment.appointmentTime.substring(0, 5)}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                      Text(
                        'Status : ${widget.appointment.appointmentStatus}',
                        style: TextStyle(
                          fontSize: 16, // Example font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kheight10,
                    ],
                  ),
                ),
              ),
            ),
            kheight10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Cancel',
                  onPressed: () async {
                    // Call the cancellation method
                    int appointmentId = int.parse(widget.appointment.appointmentId);
                    // Call the cancellation method with the converted appointmentId
                    await Parent().changeAppointmentStatus([appointmentId]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appointment canceled successfully'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    Navigator.pop(context,true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
