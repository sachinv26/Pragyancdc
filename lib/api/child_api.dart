import 'dart:convert';

import 'package:pragyan_cdc/model/child_model.dart';
import 'package:http/http.dart' as http;

class ChildApi {
  //to fetch child list
  Future<List<ChildModel>> getChildList(String userId, String userToken) async {
    final Map<String, String> headers = {
      'praguserid': userId,
      'pragusertoken': userToken,
    };

    const String apiUrl = 'https://askmyg.com/parentboard/get_childlist';

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          final List<dynamic> childInfoList = jsonResponse['child_info'];
          final List<ChildModel> childList = childInfoList
              .map((childInfo) => ChildModel.fromJson(childInfo))
              .toList();
          return childList;
        } else {
          // Handle API error
          print('API Error: ${jsonResponse['message']}');
          return [];
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      return [];
    }
  }

  //to add new child
  Future<Map<String, dynamic>> addNewChild({
    required String userId,
    required String userToken,
    required Map<String, String> childDetails,
  }) async {
    const String apiUrl = 'https://askmyg.com/parentboard/set_addnewchild';

    final Map<String, String> headers = {
      'praguserid': userId,
      'pragusertoken': userToken,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(childDetails),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
        return {'status': 0, 'message': 'Failed to add child'};
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      return {'status': 0, 'message': 'Failed to add child'};
    }
  }

  //to edit existing child
  Future<Map<String, dynamic>> editChild({
    required String userId,
    required String userToken,
    required String childId,
    required Map<String, String> childDetails,
  }) async {
    const String apiUrl = 'https://askmyg.com/parentboard/set_editexitingchild';

    try {
      final Map<String, String> headers = {
        'praguserid': userId,
        'pragusertoken': userToken,
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> requestBody = {
        'prag_child_name': childDetails['prag_child_name'] ?? '',
        'prag_child_dob': childDetails['prag_child_dob'] ?? '',
        'prag_child_gender': childDetails['prag_child_gender'] ?? '',
        'prag_child_relation': childDetails['prag_child_relation'] ?? '',
        'prag_child_id': childId,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      return responseData;
    } catch (e) {
      // Handle exceptions, e.g., network errors
      print('Error making API call: $e');
      return {'status': 0, 'message': 'An error occurred'};
    }
  }
}
