import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/booked_client_details.dart';

class TherapistHome extends StatefulWidget {
  const TherapistHome({super.key});

  @override
  _TherapistHomeState createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  int _selectedIndex = 0;

  void onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0, // No elevation
              leading: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png',
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dr. Amrita Rao',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Speech & Language Therapy',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Handle notification icon press.
                  },
                ),
              ],
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                LocationSearch(),
                kheight30, // Your widget for searching location
                TabBar(
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.green,
                  indicatorWeight: 4,
                  labelColor: Colors.green,
                  controller: _tabController,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      //  color: Colors.green,
                      borderRadius: BorderRadius.circular(5)),
                  tabs: const <Widget>[
                    Tab(
                      text: 'Today Appointments',
                    ),
                    Tab(
                      text: 'Upcoming schedule',
                    ),
                  ],
                ),
                Expanded(
                  // Wrap the TabBarView in an Expanded widget
                  child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[
                      // Content for the "Today Appointments" tab
                      AppointmentDetails()
                      // Content for the "Upcoming schedule" tab
                      ,
                      AppointmentDetails(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AppointmentDetails extends StatelessWidget {
  const AppointmentDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ClientDetails();
                },
              ));
            },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/images/cute_little_girl.png',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Child Name: Yuvaganesh',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        kheight10,
                        const Text(
                          'Parents Name: Baskaran',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        kheight10,
                        const Text(
                          'Status: New Client',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🕑: 11.30 AM',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        kheight10,
                        const Text('📆: 16/10/2023',
                            style: TextStyle(color: Colors.grey, fontSize: 11)),
                        kheight10,
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green)),
                          child: const Text(
                            'Pending',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return kheight10;
        },
        itemCount: 5);
  }
}

// class TherapistHome extends StatelessWidget {
  // const TherapistHome({super.key});

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

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(13),
  //     child: Column(
  //       children: [
  //         LocationSearch(),
  //         kheight10,
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(5),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(
  //                     color: Colors.green,
  //                   )),
  //               child: const Text(
  //                 'Today Appointments',
  //                 style: TextStyle(
  //                     color: Colors.green,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.all(5),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(
  //                     color: Colors.black,
  //                   )),
  //               child: const Text(
  //                 'Upcoming schedule',
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.w400,
  //                     fontSize: 16),
  //               ),
  //             )
  //           ],
  //         ),
  //         Expanded(
  //           child: ListView.separated(
  //             itemCount: 5,
  //             itemBuilder: (context, index) {
  //               return Card(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: ListTile(
  //                     contentPadding: const EdgeInsets.all(16),
  //                     leading:
  //                         Image.asset('assets/images/cute_little_girl.png'),
  //                     title: const Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Child Name: Yuvaganesh',
  //                           style: TextStyle(
  //                               fontSize: 10, fontWeight: FontWeight.bold),
  //                         ),
  //                         Text(
  //                           'Parents Name: Baskaran',
  //                           style: TextStyle(
  //                               fontSize: 10, fontWeight: FontWeight.bold),
  //                         ),
  //                         Text(
  //                           'Status: New Client',
  //                           style: TextStyle(
  //                               fontSize: 10, fontWeight: FontWeight.bold),
  //                         ),
  //                       ],
  //                     ),
  //                     trailing: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         const Text(
  //                           '11:30 AM',
  //                           style: TextStyle(fontSize: 11),
  //                         ),
  //                         const Text('16/10/2023',
  //                             style: TextStyle(fontSize: 11)),
  //                         OutlinedButton(
  //                           onPressed: () {
  //                             // Handle button press
  //                           },
  //                           child: const Text('Pending',
  //                               style: TextStyle(fontSize: 11)),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (context, index) {
  //               return const SizedBox(
  //                 height: 10,
  //               );
  //             },
  //           ),
  //         )
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
  //       ],
  //     ),
  //   );
  // }
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
// }

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

