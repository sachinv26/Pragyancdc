import 'package:flutter/material.dart';
import 'package:pragyan_cdc/model/full_signup_model.dart';

class SignUpDataProvider extends ChangeNotifier {
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController childDOBController = TextEditingController();
  final TextEditingController mailIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

//Method to submit the form and create a FullSignUpModel instance.
  FullSignUpModel submitForm() {
    return FullSignUpModel(
        parentName: parentNameController.text,
        childName: childNameController.text,
        childDOB: childDOBController.text,
        email: mailIdController.text,
        location: locationController.text,
        address: addressController.text,
        password: passwordController.text,
        phoneNumber: phoneNumberController.text);
  }

  @override
  void dispose() {
    parentNameController.dispose();
    childNameController.dispose();
    childDOBController.dispose();
    mailIdController.dispose();
    locationController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
