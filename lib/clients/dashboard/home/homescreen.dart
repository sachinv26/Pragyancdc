import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:carousel_slider/carousel_slider.dart';
class HomeScreen extends StatefulWidget {
  // final BuildContext ctx;
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocationProvider locationProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String branchId = ''; // Fix: Remove final keyword
  String branchName = ''; // Fix: Remove final keyword
  final List<String> imgList = [
    'assets/images/children.png',
    'assets/images/children-learning-globe-with-woman-bedroom 1.png',
  ];

  Future<List<dynamic>> fetchLocations() async {
    final response = await ApiServices().getBranches();
    return response['branch'];
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
            return Scaffold(
              backgroundColor: Colors.white70,
                key: _scaffoldKey,
                endDrawerEnableOpenDragGesture: false,
                drawer: ClientAppDrawer(),
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
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
                                radius: 20,
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
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile.parentName.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications,
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
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                        ),
                        items: imgList
                            .map((item) => Container(
                          child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(item, fit: BoxFit.cover, width: 1000),
                                    Positioned(
                                      left: 8,
                                      top: 10,
                                      child: Image.asset(
                                        'assets/images/Pragyan-Logo-New__1_-removebg-preview 1.png',
                                      ),
                                    ),

                                  ],
                                ),
                              )),
                        ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: FutureBuilder(
                        future: fetchLocations(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Loading());
                          } else if (snapshot.hasError) {
                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            var data = snapshot.data!;
                            // Initialize branchName based on the first available location data
                            // if (branchName.isEmpty && data.isNotEmpty) {
                            //   branchId = data[0]['bran_id'];
                            //   branchName = data[0]['bran_name'];
                            // }
                            return DropdownButton2(
                              hint: const Text('Please Choose a branch', style: TextStyle(color: Colors.white)),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                ),
                                iconSize: 20,
                                iconEnabledColor: Colors.white,
                                iconDisabledColor: Colors.grey,
                              ),
                              buttonStyleData: ButtonStyleData(
                                width: double.maxFinite,
                                padding: const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.green.shade600,
                                ),
                                elevation: 2,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.green.shade600,
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                              value: branchId.isEmpty ? null : branchId, // Set initial value to null if branchId is empty
                              items: data.map((location) {
                                String branchId = location['bran_id'];
                                String branchName = location['bran_name'];
                                return DropdownMenuItem(
                                  value: branchId,
                                  child: Text(
                                    branchName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    branchId = value.toString(); // Update locally managed branchId
                                    branchName = data.firstWhere((element) => element['bran_id'] == value)['bran_name'];
                                    // No need to call locationProvider.updateSelectedLocation here
                                    // Update branchName
                                  }
                                });
                              },
                            );
                          } else {
                            return const Text('No data available');
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Our Services',
                        style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    kheight10,
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20),
                      child: FutureBuilder(
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
                                  for (var i = 0; i < therapies.length; i += 3)
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
                                                  userId:
                                                      userProfile.parentUserId,
                                                  therapy: therapy,
                                                  branchId: branchId,
                                                  branchName:
                                                      branchName, // Pass the correct branchName here
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                ],
                              );
                            }
                          }),
                    ),
                  ],
                ));
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
    print("branch id is this " +
        widget.branchId +
        "branch name is " +
        widget.branchName);
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
                style: TextStyle(
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
