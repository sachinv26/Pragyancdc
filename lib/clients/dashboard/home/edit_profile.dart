import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/appbar.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    child: Image.asset(
                        'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
                  ),
                  const Icon(Icons.camera),
                  const Text('Profile Picture')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField('Name', 'Arun'),
                    buildTextField('Child Name', 'Gowtham'),
                    buildTextField('DOB', 'DD/MM/YYYY', hasEditIcon: false),
                    buildTextField('Mobile Number', '9876543210'),
                    buildTextField('Email', 'Arun77@gmail.com'),
                    buildTextField('Qualification', 'Therapist'),
                    buildTextField('Experience', '5 Years'),
                    buildTextField('Specialist', 'Speech & Language Therapy'),
                    const SizedBox(height: 16.0),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Handle form submission
                    //   },
                    //   child: const Text('Submit'),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, {bool hasEditIcon = true}) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: hasEditIcon
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                },
              )
            : null,
      ),
    );
  }
}
