import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/clients/dashboard/child/edit_child.dart';

import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'dart:async';

class ChildList extends StatefulWidget {
  const ChildList({Key? key}) : super(key: key);

  @override
  _ChildListState createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  @override
  Widget build(BuildContext context) {
    //  var selectedChildImageProvider = Provider.of<ChildImageProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addChildScreen');
          // Check if the result is not null, and rebuild the screen if needed
          if (result != null) {
            // Do something with the result (e.g., update UI)
            setState(() {});
            print('Received result from ScreenB: $result');
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: customAppBar(title: 'My Children'),
      body: FutureBuilder<List<ChildModel>?>(
        future: getChildListfromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No Children Found'));
          } else {
            final List<ChildModel> childList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  kheight30,
                  Expanded(
                    child: ListView.separated(
                      itemCount: childList.length,
                      itemBuilder: (context, index) {
                        final ChildModel childData = childList[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 192, 228, 193),
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding : EdgeInsets.all(7),
                                    child: CircleAvatar(
                                      radius: 35,
                                      child: ClipOval(
                                        child: Image.network(
                                          "https://dev.cdcconnect.in/${childData.childImage}",
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context, Object error,
                                              StackTrace? stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kheight10,
                                  Text(
                                    childData.childName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                  kheight10,
                                  Text(
                                    'Gender : ${childData.childGender}',
                                    style: khintTextStyle,
                                  ),
                                  kheight10,
                                  Text(
                                    'DOB : ${childData.childDob}',
                                    style: khintTextStyle,
                                  ),
                                  kheight10,
                                  Text(
                                    'Relation: ${childData.relationship}',
                                    style: khintTextStyle,
                                  ),
                                ],
                              ),
                              kwidth30,

                              kwidth30,
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // Handle edit button click
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return EditChildScreen(
                                            childData: childData,
                                          );
                                        },
                                      ));
                                      if (result != null) {
                                        // Do something with the result (e.g., update UI)
                                        setState(() {});
                                        print(
                                            'Received result from ScreenB: $result');
                                      }
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      // Handle delete button click
                                      final result =
                                          await confirmAndDeleteChild(
                                              context, childData.childId);
                                      if (result != null) {
                                        setState(() {});
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }



  Future<List<ChildModel>?> getChildListfromApi() async {
    // Use FlutterSecureStorage to get userId and token
    final userId = await const FlutterSecureStorage().read(key: 'userId');
    final token = await const FlutterSecureStorage().read(key: 'authToken');
    debugPrint('got userId and token');
    debugPrint(userId);
    debugPrint(token);

    if (userId != null && token != null) {
      // Use UserApi to fetch the user profile
      return ChildApi().getChildList(userId, token);
    } else {
      return null;
    }
  }

  // delete child
  Future confirmAndDeleteChild(BuildContext context, String childId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this child?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, do not delete
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, delete
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // User confirmed, call the deleteChild API
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final token = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && token != null) {
        Map<String, dynamic> result = await ChildApi().deleteChild(
          userId: userId,
          userToken: token,
          childId: childId,
        );

        if (result['status'] == 1) {
          Fluttertoast.showToast(
            msg: result['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          print('Child deleted successfully');
          return result;
          // Add any additional logic after successful deletion
        } else {
          Fluttertoast.showToast(
            msg: result['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          print('Failed to delete child: ${result['message']}');
        }
      }
    }
  }
}



