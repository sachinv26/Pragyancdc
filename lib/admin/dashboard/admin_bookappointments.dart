import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';




class AdminBookingAppointments extends StatefulWidget {
  const AdminBookingAppointments({super.key});

  @override
  State<AdminBookingAppointments> createState() => _AdminBookingAppointmentsState();
}

class _AdminBookingAppointmentsState extends State<AdminBookingAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: 'Book Appointments'
      ),
    );
  }
}
