import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/client_login/signup2.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_button.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/temp_signup_model.dart';

import 'package:pragyan_cdc/provider/user_signup_data.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';

class ClientSignUp extends StatefulWidget {
  final String phoneNumber;

  const ClientSignUp({required this.phoneNumber, super.key});

  @override
  State<ClientSignUp> createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  List<dynamic> branches = [];
  String parentErr = '';
  String childErr = '';
  String mailErr = '';
  String dobErr = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic selectedBranchId;
  String _selectedGender = 'male';

  late SignUpDataProvider signUpDataProvider;

  @override
  void initState() {
    super.initState();
    signUpDataProvider = Provider.of<SignUpDataProvider>(context, listen: false);
    _getCurrentLocation();
  }

  Future<List<dynamic>> fetchLocations() async {
    final response = await ApiServices().getBranches();
    return response['branch'];
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      setState(() {
        signUpDataProvider.addressController.text = address;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    signUpDataProvider = Provider.of<SignUpDataProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 10, bottom: 10),
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kheight10,
                    const Center(
                      child: Text(
                        'Welcome Back!',
                        style: kTextStyle2,
                      ),
                    ),
                    kheight10,
                    const Text(
                      'Enroll to Pragyan',
                      style: kTextStyle1,
                    ),
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Parent Name',
                      iconData: const Icon(Icons.person),
                      controller: signUpDataProvider.parentNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                      hintText: 'Child Name',
                      iconData: const Icon(Icons.person),
                      controller: signUpDataProvider.childNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            childErr = 'Please enter child name';
                          });
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
                        Expanded(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              controller: signUpDataProvider.childDOBController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                hintText: 'Child DOB - DD/MM/YYYY',
                                contentPadding: const EdgeInsets.all(10),
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) {
                                if (value.length == 2 || value.length == 5) {
                                  signUpDataProvider.childDOBController.value =
                                      TextEditingValue(
                                        text: value.substring(0, value.length - 1) +
                                            '-' +
                                            value.substring(value.length - 1),
                                        selection: TextSelection.collapsed(
                                            offset: value.length),
                                      );
                                }
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _selectDate(context, signUpDataProvider);
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
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
                    CustomTextFormField(
                      hintText: 'Enter your Mail id',
                      iconData: const Icon(Icons.email),
                      controller: signUpDataProvider.mailIdController,
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
                    Text(
                      mailErr,
                      style: const TextStyle(color: Colors.red),
                    ),
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
                              var data = snapshot.data;
                              return DropdownButton(
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
                    kheight10,
                    CustomTextFormField(
                      hintText: 'Address (Optional)',
                      controller: signUpDataProvider.addressController,
                    ),
                    kheight30,
                    Center(
                      child: CustomButton(
                        text: 'Next',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            TempModel tempModeltoPass = TempModel(
                              parentName: signUpDataProvider.parentNameController.text,
                              childName: signUpDataProvider.childNameController.text,
                              childDOB: signUpDataProvider.childDOBController.text,
                              mailId: signUpDataProvider.mailIdController.text,
                              location: selectedBranchId,
                              gender: _selectedGender,
                              address: signUpDataProvider.addressController.text,
                              mobileNumber: widget.phoneNumber,
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return SignupSecond(tempModel: tempModeltoPass);
                              },
                            ));
                          }
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

  Future<void> _selectDate(BuildContext context, SignUpDataProvider signUpDataProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        signUpDataProvider.childDOBController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}
