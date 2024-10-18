import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());
  final List<String?> _errors = List.filled(5, null);

  @override
  void initState() {
    super.initState();
    _loadSavedNumbers();
  }

  Future<void> _loadSavedNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      _controllers[i].text = prefs.getString('number_$i') ?? '';
    }
  }

  Future<void> _saveNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      await prefs.setString('number_$i', _controllers[i].text);
    }
    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Numbers saved successfully!')));
  }

  bool _validatePhoneNumber(String number) {
    // Simple regex for phone number validation (adjust as needed)
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(number);
  }

  void _validateAndSave() {
    bool isValid = true;
    for (int i = 0; i < 5; i++) {
      if (_controllers[i].text.isEmpty) {
        _errors[i] = 'This field cannot be empty';
        isValid = false;
      } else if (!_validatePhoneNumber(_controllers[i].text)) {
        _errors[i] = 'Invalid phone number';
        isValid = false;
      } else {
        _errors[i] = null; // Clear any previous error
      }
    }

    if (isValid) {
      _saveNumbers();
    }

    setState(() {}); // Update UI to show errors if any
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter up to 5 mobile numbers:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            for (int i = 0; i < 5; i++)
              TextField(
                controller: _controllers[i],
                decoration: InputDecoration(
                  labelText: 'Mobile Number ${i + 1}',
                  errorText: _errors[i],
                ),
                keyboardType: TextInputType.phone,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _validateAndSave,
              child: Text('Save Numbers'),
            ),
          ],
        ),
      ),
    );
  }
}
