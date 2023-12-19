import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Check if the user is logged in based on the presence of the authentication token
  Future<void> checkLoginStatus() async {
    String? authToken = await _storage.read(key: 'authToken');
    _isLoggedIn = authToken != null;
    notifyListeners();
  }

  // Log in the user and update the authentication status
  Future<void> login(String authToken) async {
    await _storage.write(key: 'authToken', value: authToken);
    _isLoggedIn = true;
    notifyListeners();
  }

  // Log out the user and update the authentication status
  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
    _isLoggedIn = false;
    notifyListeners();
  }
}
