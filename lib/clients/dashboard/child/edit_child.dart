import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/shared/loading.dart'; // Import your loading widget

import '../../../api/auth_api.dart';

class EditChildScreen extends StatefulWidget {
  final ChildModel childData; // Pass the existing ChildModel to the Edit screen

  const EditChildScreen({Key? key, required this.childData}) : super(key: key);

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  static const List<String> relation = ['Parent', 'Guardian'];

  String _imagepath = '';
  String dropdownValue = relation.first;
  String _selectedGender = ''; // Initialize with an empty string
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  bool _loading = false; // Added loading state variable

  @override
  void initState() {
    super.initState();

    _imagepath = "https://cdcconnect.in/${widget.childData.childImage}";
    nameController.text = widget.childData.childName;
    dobController.text = widget.childData.childDob;
    dropdownValue = widget.childData.relationship;
    _selectedGender = widget.childData.childGender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Edit Child'),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  await _pickImageFromGallery(widget.childData);
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
                const Text(
                  'Name',
                  style: kTextStyle1,
                ),
                kheight10,
                CustomTextFormField(
                  hintText: ' Child Name',
                  iconData: const Icon(Icons.person),
                  controller: nameController,
                ),
                kheight30,
                Row(
                  children: [
                    const Text(
                      'Child DOB',
                      style: khintTextStyle,
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // Open date picker when tapping on Child DOB field
                          dobController.text =
                              (await _selectDate(context, dobController.text))!;
                          // After date is selected, update the text field
                        },
                        child: CustomTextFormField(
                          hintText: 'DD/MM/YYYY',
                          controller: dobController,
                          enabled: false,
                        ),
                      ),
                    )
                  ],
                ),
                kheight30,
                Row(
                  children: [
                    const Text(
                      'Relationship:',
                      style: khintTextStyle,
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: relation
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                kheight30,
                Row(
                  children: [
                    const Text(
                      'Gender:',
                      style: khintTextStyle,
                    ),
                    Radio<String>(
                      value: 'male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Male'),
                    const SizedBox(width: 4.0),
                    Radio<String>(
                      value: 'female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Female'),
                    const SizedBox(width: 4.0),
                    Radio<String>(
                      value: 'other',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Other'),
                  ],
                ),
                kheight30,
                CustomButton(
                  text: 'Save Changes',
                  onPressed: () async {
                    final result =
                        await submitEditForm(context, widget.childData.childId);
                    if (context.mounted) {
                      Navigator.of(context).pop(result);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Rest of the code...

  Future<String?> _selectDate(
      BuildContext context, String dobController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1997),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      // Update the Child DOB field with the selected date
      dobController = picked.toLocal().toString().split(' ')[0];
      // Save the selected date to the separate controller
      return dobController;
    }
    return null;
  }

  Future submitEditForm(BuildContext context, String childId) async {
    final name = nameController.text;
    final gender = _selectedGender;
    final dob = dobController.text;
    final relation = dropdownValue;

    Map<String, String> childDetails = {
      'prag_child_name': name,
      'prag_child_dob': dob,
      'prag_child_gender': gender,
      'prag_child_relation': relation,
    };

    final userId = await const FlutterSecureStorage().read(key: 'userId');
    final token = await const FlutterSecureStorage().read(key: 'authToken');

    if (userId != null && token != null) {
      Map<String, dynamic> result = await ChildApi().editChild(
        userId: userId,
        userToken: token,
        childId: childId,
        childDetails: childDetails,
      );

      if (result['status'] == 1) {
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        debugPrint('Child edited successfully');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Failed to edit child: ${result['message']}');
      }
    }
  }

  Future<String?> _pickImageFromGallery(ChildModel childModel) async {
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
              {"child_id": childModel.childId, "call_from": 2},
              imageFile,
              userId,
              token);
          if (response['status'] == 1) {
            debugPrint('Image uploaded successfully');
            debugPrint('Image saved in ${response["path"]}');
            setState(() {
              _loading =
                  false; // Set loading state to false after uploading image
            });
            return "https://cdcconnect.in/${response["path"]}"; // Return the path to update the image
          } else {
            setState(() {
              _loading =
                  false; // Set loading state to false if image upload fails
            });
            print('Image upload failed: ${response['message']}');
            return null;
          }
        } catch (e) {
          setState(() {
            _loading =
                false; // Set loading state to false if error occurs during image upload
          });
          debugPrint('Error uploading image: $e');
          return null;
        }
      }
    }
    return null; // Return null if image selection fails
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
