import 'package:dio/dio.dart';

class UserAPI {
  static const String baseUrl = 'http://192.168.1.212:8080/user-api/';

  static Future<Response> registerUser(Map<String, dynamic> jsonData) async {
    final url = Uri.parse('${baseUrl}create-user');

    try {
      final response = await Dio().post(
        url.toString(),
        data: jsonData,
        options: Options(
          contentType: 'application/json',
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
        ),
      );

      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.data}');

      return response;
    } catch (error) {
      // Handle error as needed
      if (error is DioError) {
        if (error.response != null) {
          // The request was made and the server responded with a status code
          print(
              'Server responded with status code: ${error.response!.statusCode}');
          print('Response data: ${error.response!.data}');
        } else {
          // Something went wrong in setting up or sending the request
          print('Error sending request: ${error.message}');
        }
        rethrow;
      }

      // Return a default response or throw the error
      return Response(
        requestOptions: RequestOptions(path: url.path),
        data: 'Default Error Message',
        statusCode: 500,
      );
      // Alternatively, you can rethrow the caught error
      // rethrow;
    }
  }
}
// import 'package:http/http.dart' as http;

// // class APIResponse {
// //   final dynamic model;
// //   final String message;
// //   final ApiResponseStatus status;
// //   APIResponse(
// //       {required this.model, required this.message, required this.status});
// // }

// // enum ApiResponseStatus { success, fail }

// class UserAPI {
//   static const String baseUrl = 'http://192.168.1.212:8080/user-api/';

//   static Future<http.Response> registerUser(
//       Map<String, dynamic> jsonData) async {
//     final url = Uri.parse('${baseUrl}create-user');
//     final response = await http.post(
//       url,
//       body: jsonData,
//     );
//     return response;
//   }
// }
