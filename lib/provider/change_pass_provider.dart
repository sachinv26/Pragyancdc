import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errText1 = '';
  String errText2 = '';
  bool isLoading = false;

  get formKey => _formKey;
  get currentPasswordController => _currentPasswordController;
  get confirmPasswordController => _confirmPasswordController;
  get newPasswordController => _newPasswordController;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      errText1 = 'Password cannot be empty';
      notifyListeners();
      return errText1;
    } else if (value.length < 6) {
      errText1 = 'Password must be at least 6 characters long';
      notifyListeners();
      return errText1;
    }
    errText1 = '';
    notifyListeners();
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      errText2 = 'Passwords do not match';
      notifyListeners();
      return errText2;
    }
    errText2 = '';
    notifyListeners();
    return null;
  }

  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      final String encodedOldPass = base64.encode(utf8.encode(currentPasswordController.text));
      final String encodedNewPass = base64.encode(utf8.encode(newPasswordController.text));
      // API call
      try {
        final response = await ApiServices().changePassword(encodedOldPass, encodedNewPass);
        if (response['status'] == 1) {
          Fluttertoast.showToast(
            msg: '${response['message']}. Log in again',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
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
        Fluttertoast.showToast(
          msg: 'An error occurred. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
