import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Make a POST request to the Node.js backend
    final response = await http.post(
      Uri.parse('http://104.197.9.162:3000/login'), // Replace with your server URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      // Check if the message indicates a successful login
      if (responseBody['message'] == "Login successful" && responseBody['token'] != null) {
        // Save the login status, token, and email to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', responseBody['token']);
        await prefs.setString('email', email);
        await prefs.setString('id', responseBody['id']);

        // Check if permissions are granted
        bool isPermissionGranted = await _checkAllPermissions();

        // Save the permission status in shared preferences
        await prefs.setBool('is_permission_given', isPermissionGranted);

        // Redirect based on permission status
        if (isPermissionGranted) {
          Navigator.pushNamed(context, '/onoff');
        } else {
          Navigator.pushNamed(context, '/permission');
        }

        // Navigate to the On/Off page if login is successful
        // Navigator.pushNamed(context, '/onoff');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
      } else {
        // Handle invalid login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } else {
      // Handle server errors or connectivity issues
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  // Function to check all required permissions
Future<bool> _checkAllPermissions() async {
  // List of permissions to check
  final List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    // Permission.vibration,
    Permission.storage,
  ];

  // Check each permission and return true if all are granted
  for (var permission in permissions) {
    if (!(await permission.isGranted)) {
      return false;
    }
  }
  return true;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
