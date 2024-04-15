import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/appointment/schedule_consultation.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:pragyan_cdc/shared/loading.dart';
import 'package:provider/provider.dart';

class AddChild extends StatefulWidget {
  final String phoneNumber;

  const AddChild({required this.phoneNumber, super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  DateTime childDOB = DateTime.now();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController childDOBController = TextEditingController();
  final TextEditingController mailIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  List<dynamic> branches = [];
  String parentErr = '';

  String childErr = '';

  String mailErr = '';
  String dobErr = '';
  // var selectedBranchId = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic selectedBranchId;
  String _selectedGender = 'male';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchLocations();

    // getBranchesData();
  }

  Future<List<dynamic>> fetchLocations() async {
    final response = await ApiServices().getBranches();
    return response['branch'];
  }

  @override
  Widget build(BuildContext context) {
    var signUpDataProvider = Provider.of<SignUpDataProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset:
      true, // This ensures that the scaffold resizes when the keyboard opens
      appBar: customAppBar(
        title: 'New Child Enrollment'
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    kheight10,
                    const Text(
                      'Enroll to Pragyan',
                      style: kTextStyle1,
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Parent Name*',
                      iconData: const Icon(Icons.person),
                      controller: parentNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // return 'Please enter parent name';
                          setState(() {
                            parentErr = 'Please enter parent name';
                          });
                        }
                        return null;
                      },
                    ),

                    Text(
                      parentErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Child Name*',
                      iconData: const Icon(Icons.person),
                      controller: childNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          childErr = 'Please enter child name';
                        }
                        return null;
                      },
                    ),
                    Text(
                      childErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    kheight10,
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
                              await _selectDate(context, signUpDataProvider);
                              // After date is selected, update the text field
                            },
                            child: CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    dobErr = 'Please select date of birth';
                                  });
                                }
                                return null;
                              },
                              hintText: 'DD/MM/YYYY*',
                              controller: childDOBController,
                              enabled: false,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      dobErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    kheight10,
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
                    CustomTextFormField(
                      hintText: 'Enter your Mail id',
                      iconData: const Icon(Icons.email),
                      controller: mailIdController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                          setState(() {
                            mailErr = 'Please enter a valid email address';
                          });
                        }
                        return null;
                      },
                    ),
                    kheight30,
                    CustomTextFormField(
                      hintText: 'Password',
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          childErr = 'Please enter child name';
                        }
                        return null;
                      },
                    ),

                    Text(
                      mailErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    // kheight10,
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
                              return Loading();
                            }
                          },
                        ),
                      ],
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Address (Optional)',
                      controller: addressController,
                    ),
                    kheight30,
                    Center(
                      child: CustomButton(
                        text: 'Next',
                        onPressed: () {
                          // Navigator.push(context,MaterialPageRoute(builder: (context)=>ScheduleAppointment()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to open date picker
  Future<void> _selectDate(
      BuildContext context, SignUpDataProvider signUpDataProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2012),
      firstDate: DateTime(1997),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      // Update the Child DOB field with the selected date
      signUpDataProvider.childDOBController.text =
      picked.toLocal().toString().split(' ')[0];
      // Save the selected date to the separate controller
      signUpDataProvider.childDOB = picked;
    }
  }
}
