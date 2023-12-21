import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/child_api.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/shared/loading.dart';

class ChildList extends StatefulWidget {
  const ChildList({super.key});

  @override
  State<ChildList> createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen where the user can add a new child
          Navigator.pushNamed(context, '/addChildScreen').then((result) {
            if (result == true) {
              // Refresh the child list when returning from addChildScreen
              setState(() {});
            }
          });
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => const AddChildScreen(),
          // ));
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
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: ElevatedButton(
                    //     onPressed: () {},
                    //     child: const Text('Add Child'),
                    //   ),
                    // ),
                    kheight30,
                    Expanded(
                      child: ListView.separated(
                        itemCount: childList.length,
                        itemBuilder: (context, index) {
                          final ChildModel childData = childList[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 192, 228, 193),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                childData.childImage == ""
                                    ? const CircleAvatar(
                                        radius: 28,
                                        backgroundImage: AssetImage(
                                            'assets/images/empty-user.jpeg'),
                                      )
                                    : CircleAvatar(
                                        radius: 28,
                                        backgroundImage:
                                            NetworkImage(childData.childImage),
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
                                    )
                                  ],
                                ),
                                kwidth30,
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete))
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    )
                  ],
                ),
              );
            }
          }),
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
}

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  String _selectedGender = 'male';

  final TextEditingController nameController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController relationController = TextEditingController();

  //final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Edit Child',
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
                    Future.delayed(const Duration(seconds: 3));
                    Navigator.pop(context, true);
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
      initialDate: DateTime(2012),
      firstDate: DateTime(2006),
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

  void submitForm(BuildContext context) async {
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
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        print('Child added successfully');
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
