import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/api/parent_api.dart';
import 'package:pragyan_cdc/clients/appointments.dart/view_detailed_appointment.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/parent_cancel_schedulemodel.dart';
import 'package:pragyan_cdc/model/parent_schedule_model.dart';
import 'package:pragyan_cdc/shared/loading.dart'; // Import your model

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String? userId;
  List<ParentSchedule>? appointments;

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
      // Fetch updated appointment data from your backend server
      List<ParentSchedule> updatedAppointments = await Parent().getParentAppointments(1); // For example, fetch upcoming appointments

      // Update the existing appointment data in your app's state
      setState(() {
        // Assign the updated appointments to a state variable or update the existing list
        // For example, if you have a state variable called 'upcomingAppointments', you can update it like this:
        appointments = updatedAppointments;
      });
    } catch (error) {
      // Handle any errors that occur during the refresh process
      print('Error refreshing appointments: $error');
      // You might want to display a snackbar or toast to notify the user about the error.
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade700, Colors.green.shade500],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green.shade700,
          title: const Text('My Appointments',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
          bottom: const TabBar(
            labelColor: Colors.white,
            dividerColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Upcoming',),
              // Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TabBarView(
            children: [
              _buildAppointmentList(context, 1),
              // _buildAppointmentList(context, 0),
              _buildCancelledAppointmentList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(BuildContext context, int status) {
    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child: FutureBuilder<List<ParentSchedule>>(
        future: Parent().getParentAppointments(status), // Replace 9 with the appropriate pragParent value
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
            return ListView.builder(
              itemCount: appointments!.length,
              itemBuilder: (context, index) {
                ParentSchedule appointment = appointments![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailScreen(appointment: appointment),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Card(
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
                              CircleAvatar(
                                radius: 25,
                                child: ClipOval(
                                  child: Image.network(
                                    "https://app.cdcconnect.in/${appointment.therapistImg}",
                                    width: 70,
                                    height: 70,
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
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Child Name: ${appointment.childName}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    kheight10,
                                    Text(
                                      'Therapist : ${appointment.therapistName}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    kheight10,
                                    Text(
                                      'Status: ${appointment.appointmentStatus}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              kwidth30,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🕑: ${appointment.appointmentTime}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  kheight10,
                                  Text(
                                    '📆: ${appointment.appointmentDate}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  kheight10,
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      kheight10,
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }


  Widget _buildCancelledAppointmentList(BuildContext context){
    return FutureBuilder<List<CancelAppointment>>(
      future: Parent().getCanelAppointments(), // Replace 9 with the appropriate pragParent value
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<CancelAppointment> appointments = snapshot.data!;
          if (appointments.isEmpty) {
            return const Center(child: Text('No  Cancelled appointments found.'));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              CancelAppointment appointment = appointments[index];
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AppointmentDetailScreen(appointment: appointment),
                  //   ),
                  // );
                },
                child: Column(
                  children: [
                    Card(
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Child Name: ${appointment.childName}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  kheight10,
                                  Text(
                                    'Therapist : ${appointment.therapistName}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  kheight10,
                                  Text(
                                    'Status: ${appointment.cancelStatus}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            kwidth30,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🕑: ${appointment.appointmentTime}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                                kheight10,
                                Text(
                                  '📆: ${appointment.appointmentDate}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                                kheight10,
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    kheight10,
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

