import 'package:flutter/material.dart';
import 'package:pragyan_cdc/admin/add_therapy/add_therapy.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/clients/dashboard/home/notification_screen.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Drawer Header
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                              'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                        ),
                        kheight30,
                        const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dr. Amrita Rao', style: kTextStyle1),
                        Text('Speech & Language Therapy',
                            style: TextStyle(color: Colors.black)),
                        Text('AmritaraoSpeech05@gmail.com',
                            style: TextStyle(color: Colors.black)),
                        Text('9876543210',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
              // Separation Line
              //   const Divider(),

              // List of items
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Pragyan'),
                onTap: () {
                  // Handle About Pragyan
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Get Help & Support'),
                onTap: () {
                  // Handle Get Help & Support
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Add therapy'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const AddTherapy();
                    },
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Setting'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Payment issue'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  // Handle Feedback
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment),
                title: const Text('Terms and Conditions'),
                onTap: () {
                  // Handle Terms and Conditions
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Handle Logout
                },
              ),
            ],
          ),
        ),
      ),
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
              title: const Text(
                'Dr. Amrita Rao',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),

              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const NotificationScreen();
                      },
                    ));
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
                kheight10,
                ElevatedButton(
                    onPressed: () {}, child: const Text('Book Apointments')),
                kheight10,
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
                      text: 'All Appointments',
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
                      AdminAppointmentsView(),
                      AdminAppointmentsView()
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

class AdminAppointmentsView extends StatelessWidget {
  const AdminAppointmentsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location : HSR Brach'),
                    Text('Child Name : Arun'),
                    Text('Parents Name : Gowtham'),
                    Text('visiting :Speech & Language Therapy'),
                    Text('Therapy : Dr. Amrita Rao'),
                    Text('Fees Amount : Paid'),
                  ],
                ),
                Column(
                  children: [Text('🕑 09:30 AM '), Text('📆 16/10/2023')],
                )
              ],
            ),
          ),
        );
      },
      itemCount: 6,
    );
  }
}
