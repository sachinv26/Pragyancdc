import 'package:flutter/material.dart';
import 'package:pragyan_cdc/clients/client_login/signup.dart';
import 'package:pragyan_cdc/model/full_signup_model.dart';

class TempModelProvider extends ChangeNotifier {
  TempModel? _tempModel;
  FullSignUpModel? _fullSignUpModel;

  FullSignUpModel? get fullSignUpModel => _fullSignUpModel;

  TempModel? get tempModel => _tempModel;

  void setTempModel(TempModel tempModel) {
    _tempModel = tempModel;
    notifyListeners();
  }

  void setFullSignUpModel(FullSignUpModel fullSignUpModel) {
    _fullSignUpModel = fullSignUpModel;
    notifyListeners();
  }
}
