import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = relation.first;
  String _selectedGender = 'male';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  XFile? uploadedImage;
  static const List<String> relation = ['Parent', 'Guardian'];

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });
    dobController.addListener(() {
      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    super.dispose();
  }

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
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Name',
                  style: kTextStyle1,
                ),
                kheight10,
                TextFormField(
                  decoration: InputDecoration(
                    hintText: ' Child Name',
                    icon: const Icon(Icons.person),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter child name';
                    }
                    return null;
                  },
                ),
                kheight30,
                const Text(
                  'Date of Birth',
                  style: kTextStyle1,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          String? selectedDate = await _selectDate(context, dobController.text);
                          if (selectedDate != null) {
                            dobController.text = selectedDate;
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.calendar_month),
                              hintText: 'DD-MMM-YYYY',
                            ),
                            controller: dobController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kheight30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Relation with the child',
                      style: kTextStyle1,
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      items: relation.map<DropdownMenuItem<String>>((String value) {
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
                kheight30,
                const Text(
                  'Child Gender:',
                  style: kTextStyle1,
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
                    if (_formKey.currentState!.validate()) {
                      final result = await submitForm(context);
                      if (context.mounted) {
                        Navigator.of(context).pop(result);
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please fill all required fields',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
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

  Future<String?> _selectDate(BuildContext context, String dobController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1997),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format the selected date
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      String formattedDate = formatter.format(picked);
      return formattedDate;
    }
    return null;
  }

  Future<Map<String, dynamic>> submitForm(BuildContext context) async {
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
        userId: userId,
        userToken: token,
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
        return result;
      } else {
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Failed to add child: ${result['message']}');
      }
    }
    return {};
  }
}
