import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pragyan_cdc/model/therapy.dart';
import 'package:http/http.dart' as http;

class TherapistApi {
  Future<List<Therapy>> fetchTherapies(String branchid) async {
    const String apiUrl =
        'https://askmyg.com/parentboard/get_theropy_frombranch';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken =
          await const FlutterSecureStorage().read(key: 'authToken');
      print('branch id $branchid');

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
}
