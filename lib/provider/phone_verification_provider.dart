import 'package:flutter/material.dart';

class PhoneVerificationProvider extends ChangeNotifier {
  String _errMessage = '';

  String get errMessage => _errMessage;

  void setErrorMessage(String message) {
    _errMessage = message;
    notifyListeners();
  }
}
