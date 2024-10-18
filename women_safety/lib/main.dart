import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/on_off_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized

  // Check login status from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Default to false if not available

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication App',
      initialRoute: isLoggedIn ? '/onoff' : '/', // Set initial route based on login status
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
