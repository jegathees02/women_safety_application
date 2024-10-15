// landing_page.dart
import 'package:flutter/material.dart';
import '../widgets/top_menu_bar.dart';

class LandingPage extends StatelessWidget {
  final bool isLoggedIn;

  const LandingPage({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuBar(isLoggedIn: isLoggedIn),
      body: ListView(
        children: [
          _buildSection(
            context,
            'https://via.placeholder.com/400', // Dummy image link
            'Welcome to WS App. This application is designed for women\'s safety.',
            true,
          ),
          _buildSection(
            context,
            'https://via.placeholder.com/400', // Another dummy image link
            'Stay connected and safe with emergency alerts and other features.',
            false,
          ),
          _buildSection(
            context,
            'https://via.placeholder.com/400', // Replace with real image later
            'Get help quickly with automated alert features when you need it the most.',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String imageUrl, String text, bool imageLeft) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (imageLeft) _buildImage(imageUrl),
          Expanded(child: _buildText(text)),
          if (!imageLeft) _buildImage(imageUrl),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(imageUrl, width: 200, height: 200, fit: BoxFit.cover),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
}
