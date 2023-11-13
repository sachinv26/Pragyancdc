import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class TherapistHome extends StatelessWidget {
  const TherapistHome({super.key});

  // final List<Appointment> todayAppointments = [
  //   Appointment(
  //     childName: 'Yuvaganesh',
  //     parentsName: 'Baskaran',
  //     status: 'New Client',
  //     time: '11:30 AM',
  //     date: '16/10/2023',
  //     appointmentStatus: 'Pending',
  //   ),
  //   // Add more appointments as needed
  // ];

  // final List<Appointment> upcomingAppointments = [
  //   Appointment(
  //     childName: 'Some Child',
  //     parentsName: 'Some Parent',
  //     status: 'Returning Client',
  //     time: '2:00 PM',
  //     date: '18/10/2023',
  //     appointmentStatus: 'Confirmed',
  //   ),
  //   // Add more appointments as needed
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          LocationSearch(),
          kheight10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green,
                    )),
                child: const Text(
                  'Today Appointments',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: const Text(
                  'Upcoming schedule',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading:
                          Image.asset('assets/images/cute_little_girl.png'),
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Child Name: Yuvaganesh',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Parents Name: Baskaran',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Status: New Client',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '11:30 AM',
                              style: TextStyle(fontSize: 11),
                            ),
                            Text('16/10/2023', style: TextStyle(fontSize: 11)),
                            // OutlinedButton(
                            //   onPressed: () {
                            //     // Handle button press
                            //   },
                            //   child: const Text('Pending',
                            //       style: TextStyle(fontSize: 11)),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 30,
                );
              },
            ),
          )
          // const DefaultTabController(
          //   length: 2,
          //   child: Column(
          //     children: [
          //       TabBar(
          //         labelColor: Colors.black,
          //         unselectedLabelColor: Colors.black,
          //         tabs: [
          //           Tab(text: 'Today Appointments'),
          //           Tab(text: 'Upcoming Schedule'),
          //         ],
          //       ),
          //       TabBarView(
          //         children: [
          //           // Content for 'Today Appointments' tab
          //           Center(child: Text('Content for Today Appointments')),

          //           // Content for 'Upcoming Schedule' tab
          //           Center(child: Text('Content for Upcoming Schedule')),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
  //   DefaultTabController(
  //     length: 2, // Number of tabs
  //     child: TabBar(
  //           tabs: [
  //             Tab(text: 'Today Appointment'),
  //             Tab(text: 'Upcoming Schedule'),
  //           ],
  //         ),
  //       ),
  //       body: TabBarView(
  //         children: [
  //           sampleTodayAppointment(),
  //           sampleTodayAppointment(),
  //           // Today Appointment Tab
  //           //  buildAppointmentList(todayAppointments),

  //           // Upcoming Schedule Tab
  //           //  buildAppointmentList(upcomingAppointments),
  //         ],
  //       ),
}

  // Widget sampleTodayAppointment() {
  //   return Card(
  //     child: ListTile(
  //       leading: const CircleAvatar(
  //         backgroundImage: AssetImage('assets/images/cute_little_girl.png'),
  //       ),
  //       title: const Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Child Name: Yuvaganesh'),
  //           Text('Parents Name: Baskaran'),
  //           Text('Status: New Client'),
  //         ],
  //       ),
  //       trailing: Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           const Text('11:30 AM'),
  //           const Text('16/10/2023'),
  //           OutlinedButton(
  //             onPressed: () {
  //               // Handle button press
  //             },
  //             child: const Text('Pending'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget buildAppointmentList(List<Appointment> appointments) {
  //   return ListView.builder(
  //     itemCount: appointments.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: CircleAvatar(
  //           backgroundImage: AssetImage('assets/images/cute_little_girl.png'),
  //         ),
  //         title: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Child Name: ${appointments[index].childName}'),
  //             Text('Parents Name: ${appointments[index].parentsName}'),
  //             Text('Status: ${appointments[index].status}'),
  //           ],
  //         ),
  //         trailing: Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text(appointments[index].time),
  //             Text(appointments[index].date),
  //             OutlinedButton(
  //               onPressed: () {
  //                 // Handle button press
  //               },
  //               child: Text(appointments[index].appointmentStatus),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

