import 'package:flutter/material.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }
}
