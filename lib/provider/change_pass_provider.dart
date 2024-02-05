import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String errText1 = '';
  String errText2 = '';

  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  get formKey => _formKey;
  get currentPasswordController => _currentPasswordController;
  get confirmPasswordController => _confirmPasswordController;
  get newPasswordController => _newPasswordController;

  @override
  void dispose() {
    super.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  String? validateCurrentPassword(String? value) {
    if (value!.isEmpty) {
      return 'Password cannot be empty'; // Return the error message
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long'; // Return the error message
    }

    return null;

    // Add validation logic for current password
  }

  String? validateNewPassword(String? value) {
    if (value!.isEmpty) {
      errText1 = 'Password cannot be empty';
      notifyListeners();
      // return 'Password cannot be empty'; // Return the error message
    } else if (value.length < 6) {
      errText1 = 'Password must be at least 6 characters long';
      notifyListeners();
      // return 'Password must be at least 6 characters long'; // Return the error message
    }

    return null;

    // Add validation logic for new password
  }

  String? validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      // return 'Passwords do not match';
      errText2 = 'Passwords do not match';
      notifyListeners();
    }
    return null;
  }

  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      final String encodedOldPass =
          base64.encode(utf8.encode(currentPasswordController.text));
      final String encodedNewPass =
          base64.encode(utf8.encode(newPasswordController.text));
      //api call
      try {
        final response =
            await ApiServices().changePassword(encodedOldPass, encodedNewPass);
        if (response['status'] == 1) {
          Fluttertoast.showToast(
            msg: '${response['message']}. Log in again',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          return;
        } else {
          Fluttertoast.showToast(
            msg: response['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        debugPrint('catch error: $e');
      }

      isLoading = false;
      notifyListeners();
    }
  }
}
