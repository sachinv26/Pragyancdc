import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  String _selectedLocation = '';
  String _branchName = '';

  String get selectedLocation => _selectedLocation;
  String get branchName => _branchName;

  void updateSelectedLocation(String newLocation, String newName) {
    _selectedLocation = newLocation;
    _branchName = newName;
    notifyListeners();
  }
}
