import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<TextEditingController> _phoneControllers = [];
  final List<TextEditingController> _emailControllers = [];
  final List<String?> _phoneErrors = [];
  final List<String?> _emailErrors = [];

  @override
  void initState() {
    super.initState();
    _loadSavedContacts();
  }

  Future<void> _loadSavedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('contact_count') ?? 0;
    for (int i = 0; i < count; i++) {
      _phoneControllers.add(TextEditingController(text: prefs.getString('phone_$i') ?? ''));
      _emailControllers.add(TextEditingController(text: prefs.getString('email_$i') ?? ''));
      _phoneErrors.add(null);
      _emailErrors.add(null);
    }

    if (_phoneControllers.isEmpty) {
      _addNewContact();
    }

    setState(() {});
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('contact_count', _phoneControllers.length);

    for (int i = 0; i < _phoneControllers.length; i++) {
      await prefs.setString('phone_$i', _phoneControllers[i].text);
      await prefs.setString('email_$i', _emailControllers[i].text);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contacts saved successfully!')));
  }

  bool _validatePhoneNumber(String number) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(number);
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _validateAndSave() {
    bool isValid = true;

    for (int i = 0; i < _phoneControllers.length; i++) {
      if (_phoneControllers[i].text.isEmpty) {
        _phoneErrors[i] = 'Phone number is required';
        isValid = false;
      } else if (!_validatePhoneNumber(_phoneControllers[i].text)) {
        _phoneErrors[i] = 'Invalid phone number';
        isValid = false;
      } else {
        _phoneErrors[i] = null;
      }

      if (_emailControllers[i].text.isEmpty) {
        _emailErrors[i] = 'Email is required';
        isValid = false;
      } else if (!_validateEmail(_emailControllers[i].text)) {
        _emailErrors[i] = 'Invalid email address';
        isValid = false;
      } else {
        _emailErrors[i] = null;
      }
    }

    if (isValid) {
      _saveContacts();
    }

    setState(() {});
  }

  void _addNewContact() {
    _phoneControllers.add(TextEditingController());
    _emailControllers.add(TextEditingController());
    _phoneErrors.add(null);
    _emailErrors.add(null);
    setState(() {});
  }

  void _removeContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _phoneControllers.removeAt(index);
                _emailControllers.removeAt(index);
                _phoneErrors.removeAt(index);
                _emailErrors.removeAt(index);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
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
            Text('Enter Contact Information:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _phoneControllers.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _phoneControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            errorText: _phoneErrors[index],
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            errorText: _emailErrors[index],
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeContact(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _validateAndSave,
              child: Text('Save Contacts'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addNewContact,
              child: Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
