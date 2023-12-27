import 'dart:io';

import 'package:flutter/material.dart';

class ChildImageProvider extends ChangeNotifier {
  File? _selectedPath;
  File? get selectedPath => _selectedPath;
  void setSelectedImage(File path) {
    _selectedPath = path;
    notifyListeners();
  }
}
