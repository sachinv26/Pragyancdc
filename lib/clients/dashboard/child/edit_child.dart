import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';

class EditChildScreen extends StatefulWidget {
  final ChildModel childData; // Pass the existing ChildModel to the Edit screen

  const EditChildScreen({Key? key, required this.childData}) : super(key: key);

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  String _selectedGender = ''; // Initialize with an empty string
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController relationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values when the screen is created
    nameController.text = widget.childData.childName;
    dobController.text = widget.childData.childDob;
    relationController.text = widget.childData.relationship;
    _selectedGender = widget.childData.childGender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Child'),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Handle form submission for editing
                    await submitEditForm(context, widget.childData.childId);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Edit Child'),
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

  Future<void> submitEditForm(BuildContext context, String childId) async {
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

        print('Child edited successfully');
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
}
