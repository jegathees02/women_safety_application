// top_menu_bar.dart
import 'package:flutter/material.dart';

class TopMenuBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;

  TopMenuBar({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Safe Women 911'),
      actions: [
        TextButton(
          onPressed: () {
            if (isLoggedIn) {
              // Navigate to another page if logged in
              Navigator.pushNamed(context, '/onoff');
            } else {
              // Stay on the landing page if not logged in
              Navigator.pushNamed(context, '/login');
            }
          },
          child: Text(
            isLoggedIn ? 'Dashboard' : 'Login',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
