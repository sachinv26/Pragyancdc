import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  String dropdownValue = relation.first;
  String _selectedGender = 'male';
  // String selectedRelationValue = 'parent';

  final TextEditingController nameController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController relationController = TextEditingController();

  XFile? uploadedImage;
  static const List<String> relation = ['Parent', 'Guardian'];
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Relation with the child',
                      style: khintTextStyle,
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      // icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      items: relation
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),

                // CustomTextFormField(
                //   controller: relationController,
                // ),
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
                    final result = await submitForm(context);
                    if (context.mounted) {
                      Navigator.of(context).pop(result);
                    }
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
        return result;

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
}
