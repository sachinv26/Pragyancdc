import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/model/therapy_model.dart';
import 'package:http/http.dart' as http;

class TherapistApi {
  static const String baseUrl = 'https://cdcconnect.in/apiservice/parentboard/';

  //fetch list of therapies
  Future<List<Therapy>> fetchTherapies(String branchid) async {
    const String apiUrl =
        'https://askmyg.com/parentboard/get_theropy_frombranch';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken =
          await const FlutterSecureStorage().read(key: 'authToken');
      // print('branch id $branchid');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'Content-Type': 'application/json',
        };

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: json.encode({"prag_branchid": branchid}),
        );

        if (response.statusCode == 200) {
          final dynamic responseBody = json.decode(response.body);

          if (responseBody != null && responseBody['status'] == 1) {
            final List<dynamic> data = responseBody['theropy'];

            if (data.isNotEmpty) {
              return data.map((json) => Therapy.fromJson(json)).toList();
            } else {
              print('No therapy records found for branchid: $branchid');
              return [];
            }
          } else {
            print('Invalid response format: $responseBody');
            throw Exception('Invalid response format');
          }
        } else {
          print(
              'Failed to load therapies. Status code: ${response.statusCode}');
          throw Exception('Failed to load therapies');
        }
      }
    } catch (e) {
      print('Error catch: $e');
    }

    return [];
  }

  //fetch therapists based on selected branch and therapy
  Future<Map<String, dynamic>> fetchTherapists(
      String branchId, String therapyId) async {
    print('branchId: $branchId therapyId: $therapyId');
    const String apiUrl = '${baseUrl}get_therapist_frombranch';
    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken =
          await const FlutterSecureStorage().read(key: 'authToken');
      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'Content-Type': 'application/json',
        };

        final response = await http.post(Uri.parse(apiUrl),
            headers: headers,
            body: jsonEncode({
              "prag_branchid": branchId,
              "prag_theropyid": therapyId,
            }));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print('API Response: $data');

          if (data['status'] == 1) {
            return data;
          } else {
            throw Exception(data['message']);
          }
        } else {
          throw Exception(
              'Failed to load data. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      return {'status': 0, 'message': e.toString()};
    }
    // Default return statement in case none of the conditions are met
    return {'status': 0, 'message': 'Unknown error occurred'};
  }
}
