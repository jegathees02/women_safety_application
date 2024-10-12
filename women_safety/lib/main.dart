import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Import dotenv package
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/permission_screen.dart';

void main() async {
  // Ensure the environment variables are loaded before running the app
  // await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication App',
      initialRoute: '/',
      routes: {
        '/1': (context) => PermissionsPage(),  // Default route to Login
        '/': (context) => const SignupScreen(), // Route to Signup
      },
    );
  }
}
