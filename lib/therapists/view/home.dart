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
