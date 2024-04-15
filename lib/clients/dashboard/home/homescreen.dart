import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/api/therapy_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/notification_screen.dart';
import 'package:pragyan_cdc/clients/dashboard/home/branch_therapy.dart';
import 'package:pragyan_cdc/clients/drawer/drawer_client.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/therapy_model.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';
import 'package:pragyan_cdc/provider/branch_provider.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext ctx;
  const HomeScreen({required this.ctx, super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late  LocationProvider locationProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String branchId=''; // Fix: Remove final keyword
  String branchName=''; // Fix: Remove final keyword

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
            locationProvider = Provider.of<LocationProvider>(context, listen: false);
            if (locationProvider.selectedLocation.isEmpty) {
              locationProvider.updateSelectedLocation(userProfile.preferredLocation, '');
            }
            branchId = locationProvider.selectedLocation;
            branchName= locationProvider.branchName;
            print(branchName);
            return Scaffold(
                key: _scaffoldKey,
                endDrawerEnableOpenDragGesture: false,
                drawer: ClientAppDrawer(ctx: widget.ctx),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  foregroundColor: Colors.white,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.green.shade700, Colors.green.shade500],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.green.shade700,
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      userProfile.profileImage == ""
                          ? GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                          AssetImage('assets/images/empty-user.jpeg'),
                        ),
                      )
                          : GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: CircleAvatar(
                          radius: 25,
                          child: ClipOval(
                            child: Image.network(
                              "https://cdcconnect.in/${userProfile.profileImage}",
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile.parentName,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black),
                          ),
                        ],
                      ),
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
                    ],
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                    child: ListView(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/images/children.png',
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            Positioned(
                              left: 8,
                              top: 10,
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
                        FutureBuilder(
                          future: fetchLocations(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!;
                              return DropdownButton(
                                value: locationProvider.selectedLocation,
                                items: data.map((location) {
                                  branchId = location['bran_id'];
                                  branchName = location['bran_name'];
                                  return DropdownMenuItem(
                                    value: branchId,
                                    child: Text(
                                      branchName,
                                      style: khintTextStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    branchId = value.toString(); // Update branchId
                                    branchName = data.firstWhere((element) => element['bran_id'] == value)['bran_name'];
                                    locationProvider.updateSelectedLocation(value.toString(), branchName);
                                    // Update branchName
                                  });
                                },
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error');
                            } else {
                              return Center(child: Loading());
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Our Services',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        kheight10,
                        FutureBuilder(
                            future: TherapistApi().fetchTherapies(branchId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Loading(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                List<Therapy> therapies = snapshot.data!;
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (var i = 0;
                                        i < therapies.length;
                                        i += 3)
                                      Row(
                                        children: therapies
                                            .sublist(
                                                i,
                                                i + 3 > therapies.length
                                                    ? therapies.length
                                                    : i + 3)
                                            .map((therapy) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ServiceItem(
                                                    userId: userProfile.parentUserId,
                                                    therapy: therapy,
                                                    branchId: branchId,
                                                    branchName: branchName, // Pass the correct branchName here
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                  ],
                                );
                              }
                            }),
                        kheight30,
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/children-learning-globe-with-woman-bedroom 1.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
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
                              left: 10,
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/fb.png'),
                                        kwidth10,
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
                                        kwidth10,
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
                    )));
          }
        });
  }
}

Future<UserProfile?> fetchUserProfile() async {
  // Use FlutterSecureStorage to get userId and token
  final userId = await const FlutterSecureStorage().read(key: 'userId');
  final token = await const FlutterSecureStorage().read(key: 'authToken');
  debugPrint('got userId and token');
  debugPrint(userId);
  debugPrint(token);

  if (userId != null && token != null) {
    // Use UserApi to fetch the user profile
    return ApiServices().fetchUserProfile(userId, token);
  } else {
    return null;
  }
}

Future<List<dynamic>> fetchLocations() async {
  final response = await ApiServices().getBranches();
  return response['branch'];
}

class ServiceItem extends StatefulWidget {
  final Therapy therapy;
  final String branchId;
  final String branchName;

  final String userId;

  const ServiceItem({
    super.key,
    required this.branchId,
    required this.branchName,
    required this.therapy,
    required this.userId,
  });

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    print("branch id is this "+ widget.branchId + "branch name is " + widget.branchName);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BranchTherapies(
                  parentid: widget.userId,
                  branchId: widget.branchId,
                  therapy: widget.therapy,
                  branchName: widget.branchName,
                )));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        // margin: const EdgeInsets.all(6),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.therapy.therapyIcon),
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
                widget.therapy.therapyName,
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
