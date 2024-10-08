import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  String _selectedLocation = '';

  String get selectedLocation => _selectedLocation;

  void updateSelectedLocation(String newLocation) {
    _selectedLocation = newLocation;
    notifyListeners();
  }
}
