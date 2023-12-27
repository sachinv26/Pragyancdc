import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/auth_api.dart';
import 'package:pragyan_cdc/clients/dashboard/home/homescreen.dart';
import 'package:pragyan_cdc/constants/appbar.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';

class EditProfile extends StatefulWidget {
  UserProfile userProfile;
  EditProfile({required this.userProfile, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

dynamic selectedBranchId;

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String trimmedPath = trimString(
        widget.userProfile.profileImage, "/public/assets/profile_img/");

    return Scaffold(
      appBar: customAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.network(
                        "https://askmyg.com/$trimmedPath",
                        width: 75,
                        height: 75,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
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
                  buildTextField(
                      'Email', widget.userProfile.parentEmail, emailController),
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
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchLocations() async {
    final response = await ApiServices().getBranches();
    return response['branch'];
  }

  Widget buildTextField(
      String label, String value, TextEditingController controller) {
    if (controller.text.isEmpty) {
      controller.text = value;
    }
    return TextFormField(
      //readOnly: true,

      controller: controller,
      onChanged: (value) {
        controller.text = value;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
