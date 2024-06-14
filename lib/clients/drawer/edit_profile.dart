import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';

class EditProfile extends StatefulWidget {
  UserProfile userProfile;
  EditProfile({required this.userProfile, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

dynamic selectedBranchId;

class _EditProfileState extends State<EditProfile> {
  String _imagepath = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagepath="https://app.cdcconnect.in/${widget.userProfile.profileImage}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          child: CircleAvatar(
                            radius: 35,
                            child: ClipOval(
                              child: Image.network(
                                _imagepath,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: Loading(),
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
                        Positioned(
                          bottom: -5,
                          right: -8,
                          child: Transform.scale(
                            scale: 0.8, // Adjust the scale factor as needed
                            child: IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                if (!_loading) {
                                  // Check if not loading before allowing image selection
                                  await _requestPermissions();
                                  final result =
                                  await _pickImageFromGallery(widget.userProfile);
                                  if (result != null && result.isNotEmpty) {
                                    setState(() {
                                      _imagepath = result;
                                    });
                                  }
                                }
                              },
                              icon: Icon(Icons.camera_alt, size: 20), // Edit icon
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text('Profile Picture')
                  ],
                ),
              ),

              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField(
                        'Name', widget.userProfile.parentName, nameController),

                    // buildTextField('DOB', 'DD/MM/YYYY', hasEditIcon: false),
                    // buildTextField('Mobile Number', '9876543210'),
                    buildTextField('Email', widget.userProfile.parentEmail,
                        emailController),
                    buildTextField('Address', widget.userProfile.parentAddress,
                        adressController),
                    kheight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          'Preferred Location',
                        ),
                        FutureBuilder(
                          future: fetchLocations(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // print('has data');
                              var data = snapshot.data;
                              // print('snapshot.data : $data');
                              //return Text(data![0]['bran_name ']);
                              return DropdownButton(
                                // hint: const Text('Preferred Location'),
                                //  isExpanded: true,
                                value: selectedBranchId ?? data![0]['bran_id'],
                                items: data!.map((location) {
                                  return DropdownMenuItem(
                                    value: location['bran_id'],
                                    child: Text(
                                      location['bran_name'],
                                      style: khintTextStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedBranchId = value;
                                    // print(SelectedBranchId);
                                  });
                                },
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error ');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),

                    Center(
                      child: CustomButton(text: 'Save Changes',onPressed: ()async{
                        Map<String, dynamic> data = {
                          'prag_parent_name': nameController.text,
                          'prag_parent_email': emailController.text,
                          'prag_preferred_location': selectedBranchId,
                          'prag_parent_address': adressController.text
                        };
                        final result = await editUserProfile(data);
                        if (context.mounted) {
                          Navigator.of(context).pop(result);
                        }
                      },),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future editUserProfile(Map<String, dynamic> inputData) async {
    final userId = await const FlutterSecureStorage().read(key: 'userId');
    final token = await const FlutterSecureStorage().read(key: 'authToken');
    if (userId != null && token != null) {
      final result =
          await ApiServices().editUserProfile(userId, token, inputData);
      if (result!['status'] == 1) {
        //success
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return result;
      } else {
        //failed
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<String?> _pickImageFromGallery(UserProfile userProfile) async {
    final api = ApiServices();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _loading = true; // Set loading state to true when uploading image
      });

      final token = await const FlutterSecureStorage().read(key: 'authToken');
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      if (userId != null && token != null) {
        try {
          File imageFile = File(image.path);
          Map<String, dynamic> response = await api.callImageUploadApi(
              {"child_id": 0, "call_from": 1},
              imageFile,
              userId,
              token);
          if (response['status'] == 1) {
            debugPrint('Image uploaded successfully');
            debugPrint('Image saved in ${response["path"]}');
            // setState(() {
            //   // _loading =
            //   // false; // Set loading state to false after uploading image
            // });
            return "https://app.cdcconnect.in/${response["path"]}"; // Return the path to update the image
          } else {
            // setState(() {
            //   // _loading =
            //   // false; // Set loading state to false if image upload fails
            // });
            print('Image upload failed: ${response['message']}');
            return null;
          }
        } catch (e) {
          // setState(() {
          //   // _loading =
          //   // false; // Set loading state to false if error occurs during image upload
          // });
          debugPrint('Error uploading image: $e');
          return null;
        }
      }
    }
    return null; // Return null if image selection fails
  }

  Future<List<dynamic>> fetchLocations() async {
    final response = await ApiServices().getBranches();
    return response['branch'];
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

  Widget buildTextField(
      String label, String value, TextEditingController controller) {
    if (controller.text.isEmpty) {
      controller.text = value;
    }
    return TextFormField(
      //readOnly: true,

      controller: controller,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
