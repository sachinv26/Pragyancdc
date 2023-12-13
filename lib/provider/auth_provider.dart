import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pragyan_cdc/api/user_api/user_api.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';

class AuthProvider extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  void login(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    notifyListeners();
  }

  Future<UserDetailsModel> fetchUserDetails(String userId) async {
    // Fetch user details from the API and return a UserDetailsModel
    final response = await UserAPI().fetchUser(
        userId); // You need to implement this method in your UserAPI class
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData['error']) {
      throw Exception('Failed to fetch user details');
    }

    return UserDetailsModel.fromJson(responseData['data']);
  }
}
