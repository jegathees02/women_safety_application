// top_menu_bar.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopMenuBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _TopMenuBarState createState() => _TopMenuBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopMenuBarState extends State<TopMenuBar> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Check if 'isLoggedIn' is set to true in shared preferences
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    // Clear shared preferences for login state, email, and token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');
    await prefs.remove('token');

    // Redirect to the landing page
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Safe Women 911'),
      actions: [
        if (isLoggedIn)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {},
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Logout') {
                    _logout(context);
                  } else if (value == 'Settings') {
                    Navigator.pushNamed(context, '/settings');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Settings', 'Logout'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 20,
                  child: Icon(
                    Icons.person, // Placeholder for the profile picture
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          )
        else
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
