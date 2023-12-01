import 'package:flutter/material.dart';

class SignUpDataProvider extends ChangeNotifier {
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController childDOBController = TextEditingController();
  final TextEditingController mailIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    parentNameController.dispose();
    childNameController.dispose();
    childDOBController.dispose();
    mailIdController.dispose();
    locationController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
