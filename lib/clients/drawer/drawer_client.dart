import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/edit_profile.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientAppDrawer extends StatelessWidget {
  final BuildContext ctx;
  ClientAppDrawer({required this.ctx, super.key});
  final api = ApiServices();

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
                GestureDetector(
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        AssetImage('assets/images/empty-user.jpeg'),
                  ),
                  onTap: () async {
                    await _requestPermissions();
                    await _pickImageFromGallery();
                  },
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
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const FaIcon(FontAwesomeIcons.whatsapp),
          //   title: const Text('Chat Support'),
          //   onTap: () {
          //     // Take to whatsapp
          //   },
          // ),
          // List of items
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const Icon(Icons.info),
            title: const Text('About Pragyan'),
            onTap: () {
              // Handle About Pragyan
            },
          ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.help),
          //   title: const Text('Get Help & Support'),
          //   onTap: () {
          //     // Handle Get Help & Support
          //   },
          // ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.history),
          //   title: const Text('History'),
          //   onTap: () {
          //     // Handle History
          //   },
          // ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.payment),
          //   title: const Text('Payment issue'),
          //   onTap: () {
          //     // Handle Payment issue
          //   },
          // ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Setting'),
          //   onTap: () {
          //     // Handle Setting
          //   },
          // ),
          // ListTile(
          //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          //   leading: const Icon(Icons.feedback),
          //   title: const Text('Feedback'),
          //   onTap: () {
          //     // Handle Feedback
          //   },
          // ),
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
            onTap: () async {
              final authtoken = await api.getToken(context);
              if (authtoken != null) {
                final response =
                    await api.parentLogout(userDetails.parentUserId, authtoken);
                if (response['status'] == 1) {
                  //logout success
                  Fluttertoast.showToast(
                    msg: "Logging out...",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  print('Logout Trigger Context: $context');
                  await Provider.of<AuthProvider>(ctx, listen: false).logout();
                } else {
                  //fail to logout
                  Fluttertoast.showToast(
                    msg: "Logout Failed",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: 16.0,
                  );
                }
              } else {
                debugPrint('Auth Token is null');
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Handle the selected image here
      // You might want to:
      // - Display the image in the CircleAvatar
      // - Upload the image to a server
      // - Store the image locally
    }
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        // Handle the case where the user denied permissions
        print('Storage permissions denied');
        return; // Or show a custom message to the user
      }
    }
  }
}
