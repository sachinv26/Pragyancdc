// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// Future<void> fetchTherapistAppointments() async {
//   // API endpoint
//   final String apiUrl = 'https://app.cdcconnect.in/apiservice/consultation/get_therapistdateappointment';
//
//   final Map<String, dynamic> body = {
//     "prag_branch": "0",
//     "prag_therapy": "0",
//     "prag_therapiest": "6",
//     "prag_fromdate": "2024-03-18",
//     "prag_todate": "2024-05-30",
//     "prag_dateorder": 1
//   };
//
//   try {
//     // Making POST request
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: json.encode(body),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );
//
//     // Checking if the request was successful (status code 200)
//     if (response.statusCode == 200) {
//       // Parsing the response body
//       final Map<String, dynamic> responseData = json.decode(response.body);
//
//       // Accessing the data from the
//       List<dynamic> therapySchedule = responseData['theropy_schedule'];
//
//       // Do something with the fetched data
//       // Example: print therapist name
//
//       // Loop through therapy schedule
//       for (var appointment in therapySchedule) {
//         // Example: print appointment date and time
//         print('Appointment Date: ${appointment['appointment_date']}, Time: ${appointment['appointment_time']}');
//       }
//     } else {
//       // If the request was not successful, print the error status code
//       print('Request failed with status: ${response.statusCode}');
//     }
//   } catch (e) {
//     // If an error occurred during the request, print the error
//     print('Error: $e');
//   }
// }
