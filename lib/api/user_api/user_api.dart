//import 'package:http/http.dart' as http;

import 'package:http/http.dart' as http;

class UserAPI {
  static const String baseUrl = 'http://192.168.1.212:8080/user-api/';

  static Future<http.Response> registerUser(
      Map<String, dynamic> jsonData) async {
    final url = Uri.parse('${baseUrl}create-user');
    final response = await http.post(
      url,
      body: jsonData,
    );
    return response;
  }
}
