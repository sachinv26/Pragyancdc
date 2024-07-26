import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/appointments.dart/multicancel_appointments.dart';
import 'package:pragyan_cdc/clients/dashboard/child/child_list.dart';
import 'package:pragyan_cdc/clients/drawer/change_password.dart';
import 'package:pragyan_cdc/clients/drawer/edit_profile.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';
import 'package:pragyan_cdc/provider/auth_provider.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:provider/provider.dart';

class ClientAppDrawer extends StatefulWidget {
  const ClientAppDrawer({super.key});

  @override
  State<ClientAppDrawer> createState() => _ClientAppDrawerState();
}

class _ClientAppDrawerState extends State<ClientAppDrawer> {
  File? _selectedImage;
  final api = ApiServices();
  late Future<Map<String, dynamic>> _appVersionFuture;

  @override
  void initState() {
    super.initState();
    _appVersionFuture = api.getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
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
                DrawerHeader(
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                  ),
                  child: Column(
                    children: [
                      userProfile.profileImage == ""
                          ? const CircleAvatar(
                        radius: 35,
                        backgroundImage:
                        AssetImage('assets/images/empty-user.jpeg'),
                      )
                          : CircleAvatar(
                        radius: 30,
                        child: ClipOval(
                          child: Image.network(
                            "https://app.cdcconnect.in/${userProfile.profileImage}",
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
                      Text(userProfile.parentName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(userProfile.parentEmail,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(userProfile.parentMobile,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                kheight10,
                _buildDrawerTile(
                    icon: const Icon(Icons.child_care),
                    title: 'Children List',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const ChildList();
                        },
                      ));
                    }),
                _buildDrawerTile(
                    icon: const Icon(Icons.edit),
                    title: 'Edit Profile',
                    onTap: () async {
                      final result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfile(
                            userProfile: userProfile,
                          )));
                      if (result != null) {
                        setState(() {});
                      }
                    }),
                _buildDrawerTile(
                    icon: const Icon(Icons.password),
                    title: 'Change Password',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ChangePasswordScreen();
                        },
                      ));
                    }),
                _buildDrawerTile(
                    icon: const Icon(Icons.cancel),
                    title: 'Cancel Appointments',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const MultiCancelAppointments();
                        },
                      ));
                    }),
                _buildDrawerTile(
                    icon: const Icon(Icons.currency_rupee),
                    title: 'Transaction History',
                    onTap: () {
                      // Handle Transaction History
                    }),
                _buildDrawerTile(
                    icon: const Icon(Icons.info),
                    title: 'About Pragyan',
                    onTap: () {
                      // Handle About Pragyan
                    }),
                _buildDrawerTile(
                    icon: const Icon(Icons.assignment,),
                    title: 'Terms and Conditions',
                    onTap: () {
                      // Handle Terms and Conditions
                    }),
                FutureBuilder<Map<String, dynamic>>(
                  future: _appVersionFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        leading: const Icon(Icons.assignment),
                        title: const Text('Version'),
                        subtitle: const Text('Loading...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: const Icon(Icons.assignment),
                        title: const Text('Version'),
                        subtitle: const Text('Error'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!['status'] != 1) {
                      return ListTile(
                        leading: const Icon(Icons.assignment),
                        title: const Text('Version'),
                        subtitle: const Text('Not available'),
                      );
                    } else {
                      final appVersion = snapshot.data!['app_version'];
                      return ListTile(
                        leading: const Icon(Icons.app_shortcut),
                        title: const Text('Version'),
                        subtitle: Text(appVersion),
                      );
                    }
                  },
                ),
                _buildDrawerTile(
                    icon: const Icon(Icons.logout),
                    title: 'Logout',
                    onTap: () async {
                      final authtoken = await api.getToken(context);
                      if (authtoken != null) {
                        final response = await api.parentLogout(
                            userProfile.parentUserId, authtoken);
                        if (response['status'] == 1) {
                          Fluttertoast.showToast(
                            msg: "Logging out...",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          await Provider.of<AuthProvider>(context,
                              listen: false)
                              .logout();
                        } else {
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
                    }),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildDrawerTile(
      {required Widget icon, required String title, required Function() onTap}) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          icon,
          SizedBox(width: 15,),
          Expanded(child: Text(title),flex: 4,),
        ],
      ),
    );
  }
}
