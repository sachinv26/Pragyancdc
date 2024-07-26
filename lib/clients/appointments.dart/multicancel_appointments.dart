import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/model/parent_schedule_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';

import '../../api/parent_api.dart';
import '../../constants/styles/styles.dart';



class MultiCancelAppointments extends StatefulWidget {
  const MultiCancelAppointments({Key? key}) : super(key: key);

  @override
  State<MultiCancelAppointments> createState() => _MultiCancelAppointmentsState();
}

class _MultiCancelAppointmentsState extends State<MultiCancelAppointments> with RouteAware {
  String? userId;
  List<ParentSchedule>? appointments;
  List<bool> _selectedAppointments = [];

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  void _getUserId() async {
    userId = (await const FlutterSecureStorage().read(key: 'userId')) ?? '';
    setState(() {}); // Trigger a rebuild to reflect the changes
  }

  Future<void> _refreshAppointments() async {
    try {
      List<ParentSchedule> updatedAppointments = await Parent().getParentAppointments(1);
      setState(() {
        appointments = updatedAppointments;
        _selectedAppointments = List<bool>.filled(appointments!.length, false);
      });
    } catch (error) {
      print('Error refreshing appointments: $error');
    }
  }

  void _cancelSelectedAppointments() async {
    List<int> selectedIndices = [];
    for (int i = 0; i < _selectedAppointments.length; i++) {
      if (_selectedAppointments[i]) {
        selectedIndices.add(int.parse(appointments![i].appointmentId));  // Convert String to int
      }
    }

    try {
      await Parent().changeAppointmentStatus(selectedIndices);
      await _refreshAppointments();
      // Remove the canceled appointments from the list
      setState(() {
        for (int i = selectedIndices.length - 1; i >= 0; i--) {
          appointments!.removeAt(selectedIndices[i]);
          _selectedAppointments.removeAt(selectedIndices[i]);
        }
      });
    } catch (error) {
      print('Failed to cancel selected appointments: $error');
      // Optionally show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Cancel Appointments',
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_outlined),
            onPressed: _cancelSelectedAppointments,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: FutureBuilder<List<ParentSchedule>>(
          future: Parent().getParentAppointments(1),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loading());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              appointments = snapshot.data!;
              if (appointments!.isEmpty) {
                return const Center(child: Text('No appointments found.'));
              }
              _selectedAppointments = List<bool>.filled(appointments!.length, false);
              return ListView.builder(
                itemCount: appointments!.length,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AppointmentCard(
                        appointment: appointments![index],
                        isSelected: _selectedAppointments[index],
                        onSelected: (bool value) {
                          setState(() {
                            _selectedAppointments[index] = value;
                          });
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class AppointmentCard extends StatefulWidget {
  final ParentSchedule appointment;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  AppointmentCard({
    required this.appointment,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: widget.isSelected,
              onChanged: (bool? value) {
                widget.onSelected(value!);
              },
            ),
            CircleAvatar(
              radius: 25,
              child: ClipOval(
                child: Image.network(
                  "https://app.cdcconnect.in/${widget.appointment.therapistImg}",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Child Name: ${widget.appointment.childName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  kheight10,
                  Text(
                    'Therapist : ${widget.appointment.therapistName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  kheight10,
                  Text(
                    'Status: ${widget.appointment.appointmentStatus}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            kwidth10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🕑: ${widget.appointment.appointmentTime.substring(0, 5)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                kheight10,
                Text(
                  '📆: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.appointment.appointmentDate))}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                kheight10,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

