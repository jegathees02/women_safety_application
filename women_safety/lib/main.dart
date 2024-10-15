import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Import dotenv package
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/on_off_page.dart';

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
        '/': (context) => LandingPage(isLoggedIn: false), // Pass the login status here
        '/dashboard': (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard')),
          body: const Center(child: Text('Welcome to the Dashboard!')),
        ),
        '/permission': (context) => PermissionsPage(),  // Default route to Login
        '/signup': (context) => const SignupScreen(), // Route to Signup
        '/login': (context) => const LoginScreen(), // Route to Login
        '/onoff': (context) => OnOffPage(),
      },
    );
  }
}
