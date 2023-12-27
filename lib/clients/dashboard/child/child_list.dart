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
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
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
        onPressed: () {
          Navigator.pushNamed(context, '/addChildScreen').then((result) {
            // if (result == true) {
            //   // Refresh the child list when returning from addChildScreen
            //   _refreshChildList();
            // }
          });
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
                        // String trimmedImagePath = trimString(
                        //     childData.childImage, "/public/assets/child_img/");
                        // String path = childData.childImage
                        //     .split('/public/assets/child_img/')[1];
                        // String path = childData.childImage
                        //     .split("/public/assets/child_img/")[1];

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
                                  // ? selectedChildImageProvider != null
                                  // ? CircleAvatar(
                                  //     radius: 30,
                                  //     backgroundImage: FileImage(
                                  //         selectedChildImageProvider
                                  //             .selectedPath!),
                                  //   )
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
                                        await _pickImageFromGallery(childData);
                                      },
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        print('child id');

                                        debugPrint(childData.childId);
                                        print(childData.childImage);
                                        debugPrint('afrer trimmig');
                                        // print(childData.childImage.split(
                                        //     '/public/assets/child_img/')[1]);
                                        // print(path);

                                        //  debugPrint(trimmedImagePath);
                                        await _requestPermissions();
                                        await _pickImageFromGallery(childData);
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: ClipOval(
                                          child: Image.network(
                                            "https://askmyg.com/public/assets/profile_img/parent_9_1703578084.jpg"

                                            ///   "https://askmyg.com/$trimmedImagePath",
                                            ,
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
                              // ? const CircleAvatar(
                              //     radius: 28,
                              //     backgroundImage: AssetImage(
                              //         'assets/images/empty-user.jpeg'),
                              //   )
                              // : CircleAvatar(
                              //     radius: 28,
                              //     backgroundImage:
                              //         NetworkImage(childData.childImage),
                              //   ),
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
                                    onPressed: () {
                                      // Handle edit button click
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return EditChildScreen(
                                            childData: childData,
                                          );
                                        },
                                      ));
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      // Handle delete button click
                                      confirmAndDeleteChild(
                                          context, childData.childId);
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

  Future<void> _pickImageFromGallery(
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
  Future<void> confirmAndDeleteChild(
      BuildContext context, String childId) async {
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

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  String _selectedGender = 'male';
  String selectedRelationValue = 'parent';

  final TextEditingController nameController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController relationController = TextEditingController();

  XFile? uploadedImage;

  //final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Add Child',
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Name',
                  style: kTextStyle1,
                ),
                kheight10,
                CustomTextFormField(
                  hintText: ' Child Name',
                  iconData: const Icon(Icons.person),
                  controller: nameController,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     childErr = 'Please enter child name';
                  //   }
                  //   return null;
                  // },
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
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     setState(() {
                          //       dobErr = 'Please select date of birth';
                          //     });
                          //   }
                          //   return null;
                          // },
                          hintText: 'DD/MM/YYYY',
                          controller: dobController,
                          enabled: false,
                        ),
                      ),
                    )
                  ],
                ),
                kheight30,
                const Text(
                  'Relation with the child',
                  style: khintTextStyle,
                ),
                CustomTextFormField(
                  controller: relationController,
                ),
                kheight30,
                const Text(
                  'Child Gender:',
                  style: khintTextStyle,
                ),
                Row(
                  children: [
                    Radio<String>(
                        value: 'male',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                            print('selected gender: $_selectedGender');
                          });
                        }),
                    const Text('Male'),
                    const SizedBox(width: 4.0),
                    Radio<String>(
                      value: 'female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                          print('selected gender: $_selectedGender');
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
                          print('selected gender: $_selectedGender');
                        });
                      },
                    ),
                    const Text('Other'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Handle form submission
                    submitForm(context);
                    // final childId = await submitForm(context);
                    // debugPrint('form submtted for child adding');

                    // if (uploadedImage != null) {
                    //   uploadImageToApi(uploadedImage!, childId);
                    // }

                    // Future.delayed(const Duration(seconds: 3));
                    // if (context.mounted) Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to open date picker
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

  submitForm(BuildContext context) async {
    // Add your logic to handle the form submission, e.g., calling an API
    // You can use the values from controllers: nameController.text, dobController.text, etc.
    // print(nameController.text);
    // print(_selectedGender);
    // print(dobController.text);
    // print(relationController.text);
    final name = nameController.text;
    final gender = _selectedGender;
    final dob = dobController.text;
    final relation = relationController.text;
    Map<String, String> childDetails = {
      'prag_child_name': name,
      'prag_child_dob': dob,
      'prag_child_gender': gender,
      'prag_child_relation': relation,
    };
    final userId = await const FlutterSecureStorage().read(key: 'userId');
    final token = await const FlutterSecureStorage().read(key: 'authToken');
    if (userId != null && token != null) {
      Map<String, dynamic> result = await ChildApi().addNewChild(
          userId: userId, userToken: token, childDetails: childDetails);

// Check the result for success or error
      if (result['status'] == 1) {
        // Updated successfully

        //final childId = result['child_id'];
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        print('Child added successfully');
        // return result['child_id'];
      } else {
        // Handle error
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Failed to add child: ${result['message']}');
      }

      // After submitting, close the popup form
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
