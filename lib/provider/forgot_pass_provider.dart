import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pragyan_cdc/api/auth_api.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? errText1;
  String? errText2;
  bool isLoading = false;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get newPasswordController => _newPasswordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateNewPassword(String? value) {
    if (value!.isEmpty) {
      errText1 = 'Password cannot be empty';
      notifyListeners();
      return errText1;
    } else if (value.length < 6) {
      errText1 = 'Password must be at least 6 characters long';
      notifyListeners();
      return errText1;
    } else {
      errText1 = null;
      notifyListeners();
      return null;
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) {
      errText2 = 'Confirm Password cannot be empty';
      notifyListeners();
      return errText2;
    } else if (value != _newPasswordController.text) {
      errText2 = 'Passwords do not match';
      notifyListeners();
      return errText2;
    } else {
      errText2 = null;
      notifyListeners();
      return null;
    }
  }

  Future<bool> forgotPassword(String phone) async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      final String encodedNewPass = base64.encode(utf8.encode(newPasswordController.text));

      try {
        final response = await ApiServices().forgotPassword(encodedNewPass, phone);
        print(response);
        isLoading = false;
        notifyListeners();

        if (response['status'] == 1) {
          Fluttertoast.showToast(
            msg: '${response['message']}.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          return true;
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
        debugPrint('Error: $e');
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
    return false;
  }
}
