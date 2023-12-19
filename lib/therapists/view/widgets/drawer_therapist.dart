import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/dashboard/home/edit_profile.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class TherapistAppDrawer extends StatelessWidget {
  const TherapistAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dr. Amrita Rao', style: kTextStyle1),
                    kheight10,
                    const Text('Speech & Language Therapy',
                        style: TextStyle(color: Colors.black)),
                    kheight10,
                    const Text('AmritaraoSpeech05@gmail.com',
                        style: TextStyle(color: Colors.black)),
                    kheight10,
                    const Text('9876543210',
                        style: TextStyle(color: Colors.black)),
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
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle Logout
            },
          ),
        ],
      ),
    );
  }
}
