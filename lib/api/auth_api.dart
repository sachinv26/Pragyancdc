import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pragyan_cdc/model/child_model.dart';
import 'package:pragyan_cdc/model/user_details_model.dart';

class ApiServices {
  static String baseUrl = 'https://askmyg.com/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

//for testing network issues
  Future testApi() async {
    final response =
        await http.get(Uri.parse('https://api.agify.io?name=meelad'));
    print(response);
  }

// API Method to generate OTP
  Future<Map<String, dynamic>> generateOtp({
    required String mobile,
    required String userId,
    required String otpFor,
  }) async {
    const String apiUrl =
        'https://askmyg.com/auth/user_generate_otp'; // Replace with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prag_mobile': mobile,
          'prag_userid': userId,
          'prag_otp_for': otpFor,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        int status = jsonResponse['status'] ?? 0;
        String message = jsonResponse['message'] ?? 'Unknown error';

        if (status == 1) {
          // OTP generated successfully
          return jsonResponse;
        } else if (status == 0) {
          // Handle specific error messages
          if (message.contains('Mobile number is invalid')) {
            return {'status': 0, 'message': 'Invalid mobile number'};
          } else if (message.contains('User id is invalid')) {
            return {'status': 0, 'message': 'Invalid user ID'};
          } else if (message.contains('Mobile number inactive')) {
            return {'status': -2, 'message': 'Inactive mobile number'};
          } else {
            return {'status': 0, 'message': 'Unknown error'};
          }
        } else {
          // Handle other status codes if needed
          return {'status': 0, 'message': 'Unknown error'};
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Error occurred while calling OTP validation API'
        };
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
      return {
        'status': 0,
        'message': 'Network error occurred while calling OTP validation API'
      };
    }
  }

//API method to validate Otp
  Future<Map<String, dynamic>> validateOtp(
      {required String mobile,
      required String userId,
      required String otpFor,
      required String otpCode}) async {
    try {
      const String apiUrl =
          'https://askmyg.com/auth//user_validate_otp'; // Replace with your actual OTP validation API endpoint

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "prag_mobile": mobile,
          "prag_userid": userId,
          "prag_otp_for": otpFor,
          "prag_otp": otpCode,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        int status = jsonResponse['status'] ?? 0;
        String message = jsonResponse['message'] ?? 'Unknown error';

        if (status == 1) {
          // OTP validated successfully
          return jsonResponse;
        } else if (status == 0) {
          if (message.contains('Mobile number is invalid')) {
            return {'status': 0, 'message': 'Invalid mobile number'};
          } else if (message.contains('User id is invalid')) {
            return {'status': 0, 'message': 'Invalid user ID'};
          } else if (message.contains('Invalid OTP')) {
            return {'status': 0, 'message': 'Invalid OTP'};
          } else {
            return {'status': 0, 'message': 'Unknown Error'};
          }
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Error occurred while calling OTP validation API',
        };
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
      return {
        'status': 0,
        'message': 'Network error occurred while calling OTP validation API',
      };
    }
    // Default return statement to handle any unforeseen cases
    return {
      'status': 0,
      'message': 'Unhandled error occurred',
    };
  }

  //API method to get branches of pragyan
  Future<Map<String, dynamic>> getBranches() async {
    const String apiUrl = 'https://askmyg.com/auth/get_pragyanbranch';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
      );
      if (response.statusCode == 200) {
        //success
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        int status = jsonResponse['status'] ?? 0;
        String message = jsonResponse['message'] ?? 'Unknown Error';
        if (status == 1) {
          //success
          return jsonResponse;
        } else if (message.contains('Record not found')) {
          return {'status': 0, 'message': 'Record not found'};
        } else {
          return {'status': 0, 'message': 'Unknown Error'};
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Unknown error occurred ',
        };
      }
    } catch (e) {
      print('catch error $e');
      return {
        "status": 0,
        "message": e,
      };
    }
  }

//API Method for client sign up
  Future<Map<String, dynamic>> parentSignup(
      Map<String, dynamic> inputData) async {
    const String apiUrl = 'https://askmyg.com/auth/parent_signup';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        print('Error: ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Unknown error occurred',
        };
      }
    } catch (e) {
      print('Catch error: $e');
      return {
        'status': 0,
        'message': 'Unknown error occurred',
      };
    }
  }

  //API Method for Client Login
  Future<Map<String, dynamic>> parentLogin(
      String phoneNo, String passwordEncoded) async {
    const String apiUrl = 'https://askmyg.com/auth/parent_login';
    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode({
            "prag_parent_mobile": phoneNo,
            "prag_parent_password": passwordEncoded
          }));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        int status = jsonResponse['status'] ?? 0;
        String message = jsonResponse['message'] ?? 'Unknown error';
        if (status == 1) {
          return jsonResponse;
        } else if (status == -2) {
          return {
            'status': 0,
            'message':
                'Mobile number is available and inactive, Please contact admin',
          };
        } else if (message.contains('Mobile number is not available')) {
          return {'status': 0, 'message': 'Mobile number is not available'};
        } else if (message.contains('Invalid password')) {
          return {'status': 0, 'message': 'Invalid password'};
        } else {
          return {'status': 0, 'message': 'Unknown error'};
        }
      } else {
        print('Error ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Unknown error occured.Try again later.'
        };
      }
    } catch (e) {
      print('Catch error: $e');
    }
    return {
      'status': 0,
      'message': 'Unhandled error occurred',
    };
  }

  //API method to logout
  Future<Map<String, dynamic>> parentLogout(
      String userId, String authtoken) async {
    const String apiUrl = "https://askmyg.com/auth/parent_logout";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'praguserid': userId, 'pragusertoken': authtoken});
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        int status = jsonResponse['status'] ?? 0;
        String message = jsonResponse['message'] ?? 'Unknown error';
        if (status == 1) {
          return jsonResponse;
        } else {
          return {'status': 0, 'message': 'User login is invalid'};
        }
      } else {
        print('Error ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Unknown error occured.Try again later.'
        };
      }
    } catch (e) {
      print('catch error: $e');
      return {
        'status': 0,
        'message': 'Unknown error occurred',
      };
    }
  }

  Future<void> setToken(String tokenValue) async {
    await _storage.write(key: 'authToken', value: tokenValue);
  }

  Future<String?> getToken(BuildContext context) async {
    String? authToken = await _storage.read(key: 'authToken');
    return authToken;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
  }

  //upload image
  Future<Map<String, dynamic>> callImageUploadApi(Map<String, dynamic> data,
      dynamic image, String userId, String token) async {
    const String apiUrl = 'https://askmyg.com/parentboard/upload_profileimage';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'praguserid': userId,
          'pragusertoken': token,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'profileimage': image,
          'data': data,
        }),
      );

      if (response.statusCode == 200) {
        // Successful API call
        print('Image uploaded successfully');
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
        // Handle success as needed
      } else {
        // API call failed
        print('Failed to upload image. Status code: ${response.statusCode}');
        // Handle failure as needed
        return {"status": 0, "message": "Failed to upload"};
      }
    } catch (error) {
      print('Error making API call: $error');
      // Handle error as needed
      return {"status": 0, "message": "Unknown error"};
    }
  }

  Future<UserProfile?> fetchUserProfile(String userId, String userToken) async {
    const String apiUrl = "https://askmyg.com/parentboard/get_profiledetail";
    final Map<String, String> headers = {
      'praguserid': userId,
      'pragusertoken': userToken,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 1) {
          final Map<String, dynamic> profileData = jsonResponse['profile'];
          return UserProfile.fromJson(profileData);
        } else {
          // Handle API error
          print('API Error: ${jsonResponse['message']}');
          return null;
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      return null;
    }
  }
}
