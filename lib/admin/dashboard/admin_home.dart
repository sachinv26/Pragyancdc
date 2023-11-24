import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/therapists/view/booked_client_details.dart';

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
      drawer: const AdminDrawer(),
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
                      text: 'Today\'s Appointments',
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
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const ClientDetails();
              },
            ));
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location : HSR Brach',
                          style: kTextStyle4,
                          // style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Child Name : Arun',
                          style: kTextStyle4,
                        ),
                        Text(
                          'Parents Name : Gowtham',
                          style: kTextStyle4,
                        ),
                        Text(
                          'visiting :Speech & Language Therapy',
                          style: kTextStyle4,
                        ),
                        Text(
                          'Therapy : Dr. Amrita Rao',
                          style: kTextStyle4,
                        ),
                        Text(
                          'Fees Amount : Paid',
                          style: kTextStyle4,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '🕑 09:30 AM ',
                          style: kTextStyle4,
                        ),
                        Text(
                          '📆 16/10/2023',
                          style: kTextStyle4,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: 6,
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                kwidth30,
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(' Admin Panel',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('admin123@gmail.com', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('65575649348', style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const FaIcon(FontAwesomeIcons.whatsapp),
            title: const Text('Chat Support'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AboutPage()),
              // );
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.headset_mic),
            title: const Text('Get Help & Support'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => HelpAndSupportPage()),
              // );
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => HistoryPage()),
              // );
            },
          ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.credit_card),
          //   title: const Text('Payment Issue'),
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => PaymentIssuePage()),
          //     // );
          //   },
          // ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => SettingsPage()),
          //     // );
          //   },
          // ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => FeedbackPage()),
              // );
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.file_copy),
            title: const Text('Terms and Conditions'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => TermsAndConditionsPage()),
              // );
            },
          ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.add),
          //   title: const Text('Add Therapy'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const AddTherapist()),
          //     );
          //   },
          // ),
          kheight30,
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              // Handle log out logic here
            },
          ),
        ],
      ),
    );
  }
}
