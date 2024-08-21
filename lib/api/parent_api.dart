import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pragyan_cdc/model/notifications_model.dart';
import 'package:pragyan_cdc/model/parent_cancel_schedulemodel.dart';
import 'package:pragyan_cdc/model/parent_schedule_model.dart';

import '../model/buffer_model.dart';
import '../model/support_ticket_model.dart';
import '../model/wallet_model.dart';


class Parent {

  static const String baseUrl = 'https://dev.cdcconnect.in/apiservice/';
  Future<List<ParentSchedule>> getParentAppointments(int status) async {
    const String apiUrl = '${baseUrl}consultation/get_parentAppoinment_listview';

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
          "prag_limitcount": 800,
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
    final Uri uri = Uri.parse('${baseUrl}consultation/set_cancelappointment');
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
        '${baseUrl}consultation/get_cancelledAppoinment_listview';

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
    final Uri uri = Uri.parse('${baseUrl}consultation/set_appointmentStatuschange');
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
    const String apiUrl = '${baseUrl}consultation/set_bufferbooking_bulk';
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

  Future<Map<String, dynamic>> removeBufferApi(Map<String, dynamic> bookingData) async {
    const String apiUrl = '${baseUrl}consultation/set_bufferthebooking';
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
              'Failed to remove the buffer. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      return {'status': 0, 'message': e.toString()};
    }

    // Default return statement in case none of the conditions are met
    return {'status': 0, 'message': 'Unknown error occurred'};
  }

  Future<Map<String, dynamic>> checkParentScheduleApi(Map<String, dynamic> bookingData) async {
    const String apiUrl = '${baseUrl}consultation/check_parentscheduledate';
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
              'Failed to check parent schedule. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      return {'status': 0, 'message': e.toString()};
    }

    // Default return statement in case none of the conditions are met
    return {'status': 0, 'message': 'Unknown error occurred'};
  }


  Future<List<Appointment>> getNotifications() async {
    const String apiUrl = '${baseUrl}parentboard/get_notification';

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

  Future<ParentWalletResponse> getWalletTransactions() async {
    const String apiUrl = '${baseUrl}parentboard/get_myWalletlistview';

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
          "prag_limitstart": 0,
          "prag_limitcount": 10,
          "prag_dateorder": 2,
          "prag_status": 0
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
            return ParentWalletResponse.fromJson(jsonResponse);
          } else if (jsonResponse['status'] == 0) {
            print('No transactions found');
            return ParentWalletResponse(
              status: jsonResponse['status'],
              message: jsonResponse['message'],
              totalTransaction: "0",
              parentWallet: jsonResponse['parent_wallet'] ?? "0",
              walletTransaction: [],
            );
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to fetch wallet transactions. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch wallet transactions.');
    }
  }

  Future<List<BufferSlot>> getBufferSlots() async {
    const String apiUrl = '${baseUrl}consultation/get_bufferingDatelist';

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
          "prag_parentid": userId,
          "prag_childid": "0"
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
            final List<dynamic> bufferScheduleList = jsonResponse['parent_schedule'];
            final List<BufferSlot> bufferSlots = bufferScheduleList
                .map((bufferSchedule) => BufferSlot.fromJson(bufferSchedule))
                .toList();
            return bufferSlots;
          } else if (jsonResponse['status'] == 0) {
            // Return an empty list when no buffer slots are found
            return [];
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to fetch buffer slots. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch buffer slots.');
    }
  }



  Future<SupportTicketResponse> fetchSupportTickets() async {
    const String apiUrl = '${baseUrl}parentboard/get_supportTicketlist';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'Content-Type': 'application/json',
        };

        final body = json.encode({
          "prag_limitstart": 0,
          "prag_limitcount": 100,
          "prag_dateorder": 2,
          "prag_status": 0,
        });

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          final responseJson = json.decode(response.body);
          if (responseJson['status'] == 1) {
            return SupportTicketResponse.fromJson(responseJson);
          } else {
            // Handle case where no tickets are available
            return SupportTicketResponse(
              status: responseJson['status'],
              message: responseJson['message'],
              supportTickets: [], totalTicket: '',
            );
          }
        } else {
          throw Exception('Failed to load support tickets. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch support tickets.');
    }
  }


  Future<Map<String, dynamic>> fetchTicketDetails(int ticketId) async {
    const String apiUrl = '${baseUrl}parentboard/get_individualTicketlist';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom':"parent",
          'Content-Type': 'application/json',
        };

        final body = json.encode({
          "prag_support_ticket_id": ticketId,
          "prag_limitstart": 0,
          "prag_limitcount": 200,
          "prag_dateorder": 1,
        });

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load ticket details. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch ticket details.');
    }
  }

  Future<Map<String, dynamic>> addCommentToTicket({
    required int ticketId,
    required String comment,
    File? image,
  }) async {
    const String apiUrl = '${baseUrl}parentboard/set_newCommentsinTicket';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom':"parent"
        };

        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.headers.addAll(headers);

        request.fields['data'] = json.encode({
          "prag_support_ticket_id": ticketId,
          "prag_support_comments": comment,
        });

        if (image != null) {
          request.files.add(await http.MultipartFile.fromPath('ticketimage', image.path));
        } else {
          // Add an empty file when no image is provided
          request.files.add(http.MultipartFile.fromString(
              'ticketimage',
              '',
              filename: 'empty.txt'
          ));
        }

        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(responseString);
          if (jsonResponse['status'] == 1) {
            return jsonResponse;
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to add comment. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to add comment.');
    }
  }


  Future<Map<String, dynamic>> createSupportTicket({
    required String title,
    required String category,
    required String comments,
    File? ticketImage,
  }) async {
    const String apiUrl = '${baseUrl}parentboard/set_newSupportTicket';

    try {
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      final userToken = await const FlutterSecureStorage().read(key: 'authToken');

      if (userId != null && userToken != null) {
        final headers = {
          'praguserid': userId,
          'pragusertoken': userToken,
          'pragusercallfrom':"parent"
        };

        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.headers.addAll(headers);

        // Add fields as JSON string under the key "data"
        final Map<String, dynamic> fields = {
          "prag_support_title": title,
          "prag_support_category": category,
          "prag_support_comments": comments,
        };

        request.fields['data'] = jsonEncode(fields);

        if (ticketImage != null) {
          request.files.add(await http.MultipartFile.fromPath('ticketimage', ticketImage.path));
        } else {
          // Add an empty file when no image is provided
          request.files.add(http.MultipartFile.fromString(
              'ticketimage',
              '',
              filename: 'empty.txt'
          ));
        }

        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(responseString);
          if (jsonResponse['status'] == 1) {
            return jsonResponse;
          } else {
            throw Exception(jsonResponse['message']);
          }
        } else {
          throw Exception('Failed to create support ticket. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception('User ID or User Token is null.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to create support ticket.');
    }
  }


  Future<Map<String, dynamic>> getAppVersion() async {
    const String apiUrl = '${baseUrl}auth/get_appVersion';
    const Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    const Map<String, dynamic> body = {
      "prag_apptype": "1"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          return jsonResponse;
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to fetch app version. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch app version.');
    }
  }
}

