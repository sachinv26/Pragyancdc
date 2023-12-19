import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  static String baseUrl = 'https://askmyg.com/auth';

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
}
