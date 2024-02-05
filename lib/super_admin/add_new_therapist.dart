import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/custom_textformfield.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class AddNewTherapist extends StatelessWidget {
  const AddNewTherapist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(5),
      child: Form(
          child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const CustomTextFormField(
                  hintText: 'Select Therapist\'s Name',
                  iconData: Icon(Icons.person_2_outlined),
                ),
                const CustomTextFormField(
                  hintText: 'Therapy Specialist',
                  iconData: Icon(Icons.medical_services_outlined),
                ),
                const CustomTextFormField(
                  hintText: 'Add Photo',
                  iconData: Icon(Icons.camera),
                ),
                const CustomTextFormField(
                  hintText: 'Enter mobile no',
                  iconData: Icon(Icons.phone),
                ),
                const CustomTextFormField(
                  hintText: 'Enter your email id',
                  iconData: Icon(Icons.email),
                ),
                const CustomTextFormField(
                  hintText: 'Create Password',
                  iconData: Icon(Icons.email),
                  obscureText: true,
                ),
                kheight60,
                ElevatedButton(onPressed: () {}, child: const Text('Done'))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
