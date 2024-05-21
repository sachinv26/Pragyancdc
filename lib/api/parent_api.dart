import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pragyan_cdc/model/notifications_model.dart';
import 'package:pragyan_cdc/model/parent_cancel_schedulemodel.dart';
import 'package:pragyan_cdc/model/parent_schedule_model.dart';


class Parent {
  Future<List<ParentSchedule>> getParentAppointments(int status) async {
    const String apiUrl =
        'https://app.cdcconnect.in/apiservice/consultation/get_parentAppoinment_listview';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom': "parent",
          'Content-Type': 'application/json',
        };

        final Map<String, dynamic> body = {
          "prag_parent": userId,
          "prag_child": "0",
          "prag_branch": "0",
          "prag_therapy": "0",
          "prag_therapiest": "0",
          "prag_limitstart": 0,
          "prag_limitcount": 500,
          "prag_dateorder": 1,
          "prag_status": status.toString()
        };

        String jsonBody = jsonEncode(body);
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonBody,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == 1) {
            final List<dynamic> parentScheduleList = jsonResponse['parent_schedule'];
            final List<ParentSchedule> parentAppointments = parentScheduleList
                .map((parentSchedule) => ParentSchedule.fromJson(parentSchedule))
                .toList();
            return parentAppointments;
          } else if (jsonResponse['status'] == 0) {
            // Return an empty list when no appointments are found
            return [];
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception(
              'Failed to fetch parent appointments. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch parent appointments.');
    }
  }



  Future<void> cancelAppointment(String appointmentId,String parentId,String appointmentDate,String appointmentTime ) async {
    final Uri uri = Uri.parse('https://app.cdcconnect.in/apiservice/consultation/set_cancelappointment');
    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(
          key: 'authToken');


      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom': "parent",
          'Content-Type': 'application/json',
        };

        final Map<String, dynamic> requestBody = {
          'prag_bookedid': appointmentId,
          'prag_parent': parentId,
          'prag_bookeddatetime': '${appointmentDate} ${appointmentTime}',
        };
        final http.Response response = await http.post(
          uri,
          headers: headers,
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          print('done');
          try {
            final Map<String, dynamic> jsonResponse = json.decode(response.body);
            print(jsonResponse);
            if (jsonResponse['status'] == 1) {
              print("cancelled successfully");
            }
          } catch (error) {
            print('Error decoding JSON response: $error');
          }
        } else {
          print('Failed to cancel the appointment. Error code: ${response.statusCode}');
        }

      } else {
        throw Exception('User ID or User Token is null.');
      }
    }catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch parent appointments.');
    }
  }



  Future<List<CancelAppointment>> getCanelAppointments() async {
    const String apiUrl =
        'https://app.cdcconnect.in/apiservice/consultation/get_cancelledAppoinment_listview';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom':"parent",
          'Content-Type': 'application/json',
        };

        final Map<String, dynamic> body = {
          "prag_parent": userId,
          "prag_child": "0",
          "prag_branch": "0",
          "prag_therapy": "0",
          "prag_therapiest": "0",
          "prag_limitstart": 0,
          "prag_limitcount": 100,
          "prag_dateorder": 1,
        };

        String jsonBody = jsonEncode(body);
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonBody,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == 1) {
            final List<dynamic> parentCancelScheduleList = jsonResponse['parent_cancelled_schedule'];
            final List<CancelAppointment> parentCancelAppointments = parentCancelScheduleList.map((parentcancelSchedule) =>
                CancelAppointment.fromJson(parentcancelSchedule))
                .toList();
            return parentCancelAppointments;
          } else if (jsonResponse['status'] == 0) {
            // Return a message indicating no cancelled appointments found
            return [];
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception(
              'Failed to fetch parent appointments. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error is here: $error');
      throw Exception('No Appointments found');
    }
  }



  Future<List<Appointment>> getNotifications() async {
    const String apiUrl = 'https://app.cdcconnect.in/apiservice/parentboard/get_notification';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final Map<String, String> headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'Content-Type': 'application/json',
        };

        final Map<String, dynamic> body = {
          "prag_notification_type": "appointment",
          "prag_limitstart": "0",
          "prag_limitcount": "0"
        };

        String jsonBody = jsonEncode(body);

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonBody,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == 1) {
            final List<dynamic> parentScheduleList = jsonResponse['parent_schedule'];
            final List<Appointment> appointments = parentScheduleList
                .map((appointment) => Appointment.fromJson(appointment))
                .toList();
            return appointments;
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to fetch notifications. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch notifications.');
    }
  }
}

