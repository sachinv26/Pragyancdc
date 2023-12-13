import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAPI {
  static const String baseUrl = 'http://192.168.1.213:8080/user-api/';

  static Future<http.Response> registerUser(
      Map<String, dynamic> jsonData) async {
    final url = Uri.parse('${baseUrl}create-user');
    final response = await http.post(
      url,
      body: jsonData,
    );
    return response;
  }

  Future<http.Response> fetchUser(String userId) async {
    final url = Uri.parse('${baseUrl}fetch-user');
    final response = await http.post(url, body: {'user_id': userId});
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<Map<String, dynamic>> loginUser(String mobile, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login-user'),
      body: {'MobileNumber': mobile, 'Password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String userId = data['data']['user_id'];
      // Store user ID in shared preferences
      await saveUserId(userId);
      return data;
    } else {
      throw Exception('Failed to Login');
    }
  }

  // Store the token
  // Save the token
  // String token = data['data']['token'];
  // _saveCredentialsAndToken(mobile, password, token);
  //       print('Authentication successful');
  //       return;
  //     } else {
  //       print('Authentication failed');
  //     }
  //   } catch (e) {
  //     print('Error during authentication: $e');
  //   }
  // }

  // void _saveCredentialsAndToken(
  //     String mobile, String password, String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mobile', mobile);
  //   await prefs.setString('password', password);
  //   await prefs.setString('token', token);
  // }

  // Future<void> storeToken(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('token', token);
  // }

  // Future<String?> retrieveToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token');
  // }

  // Future<void> clearToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('token');
  // }

  //  Future<void> logout() async {
  //   print('before log out');
  //   //Clear the stored token on logout
  //   await clearToken();
  //   print('Logged out successfully');
  // }
}

// import 'package:dio/dio.dart';

// class UserAPI {
//   static const String baseUrl = 'http://192.168.1.213:8080/user-api/';

//   static Future<Response> registerUser(
//     Map<String, dynamic> jsonData,
//     // File? empFace, String? empCode
//   ) async {
//     print('entered function');
//     final url = Uri.parse('${baseUrl}create-user');

//     try {
//       print('inside try');
//       print('json data :');
//       print(jsonData);

//       // FormData formData = FormData.fromMap({
//       //   ...jsonData,
//       //   // Add other fields as needed
//       //   // Add image field to the form data
//       //   'ProfileImage':
//       //       await MultipartFile.fromFile(empFace!.path, filename: empCode),
//       // });

//       // print('formdata created');
//       // // Print the fields of the FormData
//       // print('FormData fields:');
//       // for (var field in formData.fields) {
//       //   print('${field.key}: ${field.value}');
//       // }

//       final response = await Dio().post(
//         url.toString(),
//         data: jsonData,
//         options: Options(
//           contentType: 'multipart/form-data',
//           sendTimeout: const Duration(milliseconds: 9000),
//           receiveTimeout: const Duration(milliseconds: 9000),
//         ),
//       );
//       print('done sending request');

//       // print('Status Code: ${response.statusCode}');
//       // print('Headers: ${response.headers}');
//       // print('Body: ${response.data}');

//       return response;
//     } catch (error) {
//       // Handle error as needed
//       if (error is DioException) {
//         if (error.response != null) {
//           // The request was made and the server responded with a status code
//           print(
//               'Server responded with status code: ${error.response!.statusCode}');
//           print('Response data: ${error.response!.data}');
//         } else {
//           // Something went wrong in setting up or sending the request
//           print('Error sending request: ${error.message}');
//         }
//         rethrow;
//       }

//       // Return a default response or throw the error
//       return Response(
//         requestOptions: RequestOptions(path: url.path),
//         data: 'Default Error Message',
//         statusCode: 500,
//       );
//       // Alternatively, you can rethrow the caught error
//       // rethrow;
//     }
//   }
// }

