import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpDataProvider extends ChangeNotifier {
  DateTime childDOB = DateTime.now();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController childDOBController = TextEditingController();
  final TextEditingController mailIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  //final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late ImagePicker _imagePicker;
  XFile? imageFile;
  File? file;

  // Constructor to initialize the _imagePicker
  SignUpDataProvider() {
    _imagePicker = ImagePicker();
  }

  // Future<void> pickImage() async {
  //   try {
  //     final pickedFile =
  //         await _imagePicker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       _imageFile = pickedFile;

  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //   }
  // }
  Future<void> getImage() async {
// Pick an image
    imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
    file = File(imageFile!.path);
//print(‘Image picked’);
    notifyListeners();
  }

  // Method to get the path of the picked image
  String? get imagePath => imageFile?.path;

  @override
  void dispose() {
    parentNameController.dispose();
    childNameController.dispose();
    childDOBController.dispose();
    mailIdController.dispose();
    locationController.dispose();
    addressController.dispose();
    // phoneNumberController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
