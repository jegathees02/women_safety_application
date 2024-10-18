// landing_page.dart
import 'package:flutter/material.dart';
import '../widgets/top_menu_bar.dart';

class LandingPage extends StatelessWidget {
  final bool isLoggedIn;

  const LandingPage({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuBar(),
      body: ListView(
        children: [
          _buildSection(
            context,
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Ftemplates.joomla-monster.com%2Fjoomla30%2Fjm-news-portal%2Fen%2Fclassifieds-ads%2Fmake-offer%2Fprofile%2Fdemo-user%2C115&psig=AOvVaw00MDqqOuQ0jWZBHCclaTGA&ust=1729097436478000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCMjhrq3skIkDFQAAAAAdAAAAABAE', // Dummy image link
            'Welcome to WS App. This application is designed for women\'s safety.',
            true,
          ),
          _buildSection(
            context,
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Ftemplates.joomla-monster.com%2Fjoomla30%2Fjm-news-portal%2Fen%2Fclassifieds-ads%2Fmake-offer%2Fprofile%2Fdemo-user%2C115&psig=AOvVaw00MDqqOuQ0jWZBHCclaTGA&ust=1729097436478000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCMjhrq3skIkDFQAAAAAdAAAAABAE', // Another dummy image link
            'Stay connected and safe with emergency alerts and other features.',
            false,
          ),
          _buildSection(
            context,
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Ftemplates.joomla-monster.com%2Fjoomla30%2Fjm-news-portal%2Fen%2Fclassifieds-ads%2Fmake-offer%2Fprofile%2Fdemo-user%2C115&psig=AOvVaw00MDqqOuQ0jWZBHCclaTGA&ust=1729097436478000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCMjhrq3skIkDFQAAAAAdAAAAABAE', // Replace with real image later
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
