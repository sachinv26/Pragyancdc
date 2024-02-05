import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  bool _isCheckingLogin = false;
  String? _userId;
  bool get isLoggedIn => _isLoggedIn;
  bool get isCheckingLogin => _isCheckingLogin;
  String? get userId => _userId;

  // Check if the user is logged in based on the presence of the authentication token
  Future<void> checkLoginStatus() async {
    _isCheckingLogin = true; // Set to true when starting to check login status
    notifyListeners();

    String? authToken = await _storage.read(key: 'authToken');
    _userId = await _storage.read(key: 'userId');
    _isLoggedIn = authToken != null;
    _isCheckingLogin = false; // Set back to false after checking login status
    notifyListeners();
  }

  // Log in the user and update the authentication status
  // Log in the user and update the authentication status
  Future<void> login(String authToken, String userIdNew) async {
    await _storage.write(key: 'authToken', value: authToken);
    await _storage.write(key: 'userId', value: userIdNew);
    _userId = userIdNew;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Log out the user and update the authentication status
  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
    await _storage.delete(key: 'userId');
    _isLoggedIn = false;
    _userId = null;
    notifyListeners();
  }
}
