// // send_alert.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:women_safety/widgets/button_listener.dart';

// class SendAlert extends ButtonListener {
//   // Send an alert to the backend server
//   Future<void> sendAlert() async {
//     final prefs = await SharedPreferences.getInstance();
//     final phone = prefs.getString('number_0') ?? ''; // Get the first phone number
//     final email = prefs.getString('email_0') ?? ''; // Get the first email
//     final token = prefs.getString('auth_token') ?? ''; // Get the token

//     if (phone.isEmpty || email.isEmpty || token.isEmpty) {
//       print("Required data is missing.");
//       return;
//     }

//     // Create the request payload
//     final payload = {
//       'phone': phone,
//       'email': email,
//     };

//     try {
//       // Make the POST request to the backend
//       final response = await http.post(
//         // Uri.parse('http:104.197.9.162:3000/alert'),
//         Uri.parse('http://localhost:3000/alert'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(payload),
//       );

//       // Check the response status
//       if (response.statusCode == 200) {
//         print("Alert sent successfully.");
//       } else {
//         print("Failed to send alert. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error occurred while sending alert: $e");
//     }
//   }
// }
