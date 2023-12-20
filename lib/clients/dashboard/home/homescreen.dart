import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/clients/dashboard/home/edit_profile.dart';
import 'package:pragyan_cdc/clients/dashboard/home/location_search.dart';
import 'package:pragyan_cdc/clients/dashboard/home/notification_screen.dart';
import 'package:pragyan_cdc/clients/dashboard/home/speech_therapy.dart';

import 'package:pragyan_cdc/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userProfile;
    return Scaffold(
      drawer: const ClientAppDrawer(),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/cute_little_girl.png'),
            ),
          ),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Text(
                    userDetails!.parentName,
                    style: const TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  onPressed: () async {
                    showdetails(context);
                  },

                  // userDetails!.parentName,
                  // style: const TextStyle(fontSize: 17, color: Colors.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                // Text(
                //   userDetails.,
                //   style: const TextStyle(
                //       fontSize: 13,
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold),
                // ),
              ],
            ),
            const Spacer(),
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
              },
            ),
          ])),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 30),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/children.png'),
                ),
                Positioned(
                  left: 8,
                  top: 5,
                  child: Image.asset(
                    'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                  ),
                ),
                const Positioned(
                  top: 40,
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      'Children learn more from what you are  than what you teach',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // const Card(
            //   elevation: 5,
            //   child: TextField('')
            // )
            LocationSearch(),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Our Services',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Column(children: [
              Row(
                children: [
                  Expanded(
                    child: ServiceItem(
                      imageUrl: 'assets/images/service-1.png',
                      serviceName: 'Speech & Language Therapy',
                    ),
                  ),
                  Expanded(
                    child: ServiceItem(
                      imageUrl: 'assets/images/service-2.png',
                      serviceName: 'Occupational Therapy',
                    ),
                  ),
                  Expanded(
                    child: ServiceItem(
                      imageUrl: 'assets/images/service-3.png',
                      serviceName: 'Physiotherapy',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ServiceItem(
                      imageUrl: 'assets/images/service-4.png',
                      serviceName: 'ABA Therapy/Behaviour Therapy',
                    ),
                  ),
                  Expanded(
                    child: ServiceItem(
                      imageUrl: 'assets/images/service-5.png',
                      serviceName: 'Special Education',
                    ),
                  ),
                  Expanded(
                    child: ServiceItem(
                      imageUrl: 'assets/images/service-6.png',
                      serviceName: 'Group Therapy',
                    ),
                  ),
                ],
              ),
            ]),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                      'assets/images/children-learning-globe-with-woman-bedroom 1.png'),
                ),
                Positioned(
                  left: 8,
                  top: 5,
                  child: Image.asset(
                    'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 5,
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/fb.png'),
                            const Text(
                              'Pragyan CDC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Image.asset('assets/images/insta.png'),
                            const Text(
                              'Pragyan CDC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String imageUrl;
  final String serviceName;

  const ServiceItem({
    super.key,
    required this.imageUrl,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SpeechTherapy()));
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width:
                  100, // Adjust the width here to control the space for the text
              child: Text(
                serviceName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign:
                    TextAlign.center, // Optional: Align the text in the center
                maxLines: 2, // Optional: Allow maximum 2 lines for the text
                overflow: TextOverflow.ellipsis, // Optional: Handle overflow
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientAppDrawer extends StatelessWidget {
  const ClientAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userProfile;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      AssetImage('assets/images/cute_little_girl.png'),
                ),
                kwidth10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userDetails!.parentName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    kheight10,
                    Text(userDetails.parentEmail,
                        style: const TextStyle(fontSize: 16)),
                    kheight10,
                    Text(userDetails.parentMobile,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          // Separation Line
          //   const Divider(),
          // Edit Profile
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              // Handle Edit Profile
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EditProfile()));
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const FaIcon(FontAwesomeIcons.whatsapp),
            title: const Text('Chat Support'),
            onTap: () {
              // Take to whatsapp
            },
          ),
          // List of items
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.info),
            title: const Text('About Pragyan'),
            onTap: () {
              // Handle About Pragyan
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.help),
            title: const Text('Get Help & Support'),
            onTap: () {
              // Handle Get Help & Support
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              // Handle History
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.payment),
            title: const Text('Payment issue'),
            onTap: () {
              // Handle Payment issue
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.settings),
            title: const Text('Setting'),
            onTap: () {
              // Handle Setting
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              // Handle Feedback
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.assignment),
            title: const Text('Terms and Conditions'),
            onTap: () {
              // Handle Terms and Conditions
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.person_add),
            title: const Text('Add Child'),
            onTap: () {
              // Handle Add Child
            },
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {},
          ),
        ],
      ),
    );
  }

  logout() {}
}

showdetails(BuildContext context) async {
  const storage = FlutterSecureStorage();
  String? authToken = await storage.read(key: 'authToken');
  final userDetails =
      Provider.of<UserProvider>(context, listen: false).userProfile;
  print(authToken);
  print(userDetails!.parentMobile);
  print(userDetails.parentName);
  print(userDetails.parentUserId);
}
