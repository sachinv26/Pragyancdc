import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/therapists/view/widgets/appointment_details.dart';


class FilterAppointments extends StatefulWidget {
  const FilterAppointments({super.key});

  @override
  State<FilterAppointments> createState() => _FilterAppointmentsState();
}

class _FilterAppointmentsState extends State<FilterAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Appointments'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Expanded(
          child: AppointmentDetails(),
        ),
      ),
    );
  }
}
