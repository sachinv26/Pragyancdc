import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
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

          // .then((result) {
          //   // if (result == true) {
          //   //   // Refresh the child list when returning from addChildScreen
          //   //   _refreshChildList();
          //   // }
          // });
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  kheight30,
                  Expanded(
                    child: ListView.separated(
                      itemCount: childList.length,
                      itemBuilder: (context, index) {
                        final ChildModel childData = childList[index];

                        // ... rest of your UI code

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
                              childData.childImage == ""
                                  ? GestureDetector(
                                      child: const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/empty-user.jpeg'),
                                      ),
                                      onTap: () async {
                                        debugPrint('child id');
                                        debugPrint(childData.childId);

                                        await _requestPermissions();
                                        final result =
                                            await _pickImageFromGallery(
                                                childData);
                                        if (result) {
                                          setState(() {});
                                        }
                                      },
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        print('child id');

                                        await _requestPermissions();

                                        final result =
                                            await _pickImageFromGallery(
                                                childData);
                                        if (result) {
                                          setState(() {});
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: ClipOval(
                                          child: Image.network(
                                            "https://askmyg.com/${childData.childImage}",
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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

  Future _pickImageFromGallery(
    ChildModel childModel,

    //ChildImageProvider childImageProvider
  ) async {
    final api = ApiServices();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // childImageProvider.setSelectedImage(File(image.path));
      // debugPrint('newly selected image is');
      // debugPrint(childImageProvider.selectedPath!.path);

      // debugPrint(
      // 'before setstate: value of childmodel.selectedimage ${childModel.selectedImage}');
      // setState(() {
      //   childModel.selectedImage = File(image.path);
      // });
      // debugPrint('after setstate: ${childModel.selectedImage}');

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
              {"child_id": childModel.childId, "call_from": 2},
              imageFile,
              userId,
              token);
          if (response['status'] == 1) {
            debugPrint('image uploaded');
            debugPrint('image saved in ${response["path"]}');
          } else {
            print('failed ${response['message']}');
          }
        } catch (e) {
          debugPrint('Error uploading image: $e');
        }
        return true;
      }
    }
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

Future uploadImageToApi(XFile image, String childId) async {
  final token = await const FlutterSecureStorage().read(key: 'authToken');
  final userId = await const FlutterSecureStorage().read(key: 'userId');
  if (userId != null && token != null) {
    try {
      File imageFile = File(image.path);
      Map<String, dynamic> response = await ApiServices().callImageUploadApi(
          {"child_id": childId, "call_from": 2}, imageFile, userId, token);
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
