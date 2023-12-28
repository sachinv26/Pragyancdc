import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/dashboard/child/child_list.dart';
import 'package:pragyan_cdc/clients/drawer/change_password.dart';
import 'package:pragyan_cdc/clients/drawer/edit_profile.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/shared/loading.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientAppDrawer extends StatefulWidget {
  final BuildContext ctx;
  const ClientAppDrawer({required this.ctx, super.key});

  @override
  State<ClientAppDrawer> createState() => _ClientAppDrawerState();
}

class _ClientAppDrawerState extends State<ClientAppDrawer> {
  File? _selectedImage;
  final api = ApiServices();

  @override
  Widget build(BuildContext context) {
    //final userDetails = Provider.of<UserProvider>(context).userProfile;
    return FutureBuilder<UserProfile?>(
        future: fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user profile'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User profile not found'));
          } else {
            final userProfile = snapshot.data!;

            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Drawer Header
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 183, 238, 174),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        userProfile.profileImage == ""
                            ? _selectedImage != null
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundImage: FileImage(_selectedImage!),
                                  )
                                : GestureDetector(
                                    child: const CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                          'assets/images/empty-user.jpeg'),
                                    ),
                                    onTap: () async {
                                      await _requestPermissions();
                                      await _pickImageFromGallery();
                                    },
                                  )
                            : GestureDetector(
                                onTap: () async {
                                  await _requestPermissions();
                                  await _pickImageFromGallery();
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: Image.network(
                                      "https://askmyg.com/${userProfile.profileImage}",
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
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                        kheight10,
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        Text(userProfile.parentName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),

                        Text(userProfile.parentEmail,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),

                        Text(userProfile.parentMobile,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  // Separation Line
                  //   const Divider(),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    leading: const FaIcon(FontAwesomeIcons.children),
                    title: const Text('Children List'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const ChildList();
                        },
                      ));
                    },
                  ),
                  // Edit Profile
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    onTap: () async {
                      // Handle Edit Profile
                      final result =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    userProfile: userProfile,
                                  )));
                      if (result != null) {
                        setState(() {});
                      }
                    },
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    leading: const Icon(Icons.password),
                    title: const Text('Change Password'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ChangePasswordScreen(
                            ctx: widget.ctx,
                          );
                        },
                      ));
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
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
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
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    leading: const Icon(Icons.assignment),
                    title: const Text('Terms and Conditions'),
                    onTap: () {
                      // Handle Terms and Conditions
                    },
                  ),

                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      final authtoken = await api.getToken(context);
                      if (authtoken != null) {
                        final response = await api.parentLogout(
                            userProfile.parentUserId, authtoken);
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
                          await Provider.of<AuthProvider>(widget.ctx,
                                  listen: false)
                              .logout();
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
        });
  }

  Future<void> _pickImageFromGallery() async {
    final api = ApiServices();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      final token = await const FlutterSecureStorage().read(key: 'authToken');
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      if (userId != null && token != null) {
        try {
          // Read the raw image data
          // List<int> imageBytes = await File(image.path).readAsBytes();
          // Convert the XFile to a File
          File imageFile = File(image.path);
          //call api
          Map<String, dynamic> response = await api.callImageUploadApi(
              {"child_id": 0, "call_from": 1}, imageFile, userId, token);
          if (response['status'] == 1) {
            debugPrint('image uploaded');
            debugPrint('image saved in ${response["path"]}');
          } else {
            print('failed ${response['message']}');
          }
        } catch (e) {
          debugPrint('Error uploading image: $e');
        }
      }
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
