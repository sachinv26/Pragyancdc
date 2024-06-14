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
          'prag_tran_note' : 'Time issue'
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
      final FlutterSecureStorage storage = FlutterSecureStorage();
      final String? userId = await storage.read(key: 'userId');
      final String? userToken = await storage.read(key: 'authToken');

      if (userId == null) {
        throw Exception('User ID is null.');
      }
      if (userToken == null) {
        throw Exception('User Token is null.');
      }

      print('User ID: $userId');
      print('User Token: $userToken');

      final Map<String, String> headers = {
        'praguserid': userId,
        'pragusertoken': userToken,
        'pragusercallfrom': 'parent',
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
      print('Request Body: $jsonBody');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          final List<dynamic> parentCancelScheduleList = jsonResponse['parent_cancelled_schedule'];
          final List<CancelAppointment> parentCancelAppointments = parentCancelScheduleList.map((parentcancelSchedule) =>
              CancelAppointment.fromJson(parentcancelSchedule)).toList();
          return parentCancelAppointments;
        } else if (jsonResponse['status'] == 0) {
          // Return an empty list indicating no cancelled appointments found
          return [];
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch parent appointments. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('No Appointments found');
    }
  }



  Future<void> changeAppointmentStatus(List<int> appointmentIds) async {
    final Uri uri = Uri.parse('https://app.cdcconnect.in/apiservice/consultation/set_appointmentStatuschange');
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

        final Map<String, dynamic> requestBody = {
          'prag_bookedid': appointmentIds,
          'prag_tran_status': 5,
          'prag_tran_note': 'parent cancelled'
        };

        final http.Response response = await http.post(
          uri,
          headers: headers,
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          print('Status changed successfully');
          try {
            final Map<String, dynamic> jsonResponse = json.decode(response.body);
            print(jsonResponse);
            if (jsonResponse['status'] == 1) {
              print("Appointments status changed successfully");
            }
          } catch (error) {
            print('Error decoding JSON response: $error');
          }
        } else {
          print('Failed to change the appointment status. Error code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to change appointment status.');
    }
  }



  Future<Map<String, dynamic>> bufferTheBookingApi(Map<String, dynamic> bookingData) async {
    const String apiUrl = 'https://app.cdcconnect.in/apiservice/consultation/set_bufferbooking_bulk';
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
        print(bookingData);
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(bookingData), // Pass the bookingData directly
        );


        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print(data);
          if (data['status'] == 1) {
            print(data);
            return data;
          } else if (data['status'] == -2) {
            // Handle the case where status is -2
            return {
              'status': -2,
              'message': data['message'],
              'bookeddate': data['bookeddate']
            };
          } else {
            throw Exception(data['message']);
          }
        } else {
          throw Exception(
              'Failed to buffer the booking. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      return {'status': 0, 'message': e.toString()};
    }

    // Default return statement in case none of the conditions are met
    return {'status': 0, 'message': 'Unknown error occurred'};
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
          "prag_limitstart": "1",
          "prag_limitcount": "100"
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
          } else if (jsonResponse['status'] == 0) {
            // Return an empty list when status is 0
            print('No notifications found');
            return [];
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

