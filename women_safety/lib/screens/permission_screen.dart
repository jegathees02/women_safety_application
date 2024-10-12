import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsPage extends StatefulWidget {
  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _cameraPermissionGranted = false;
  bool _microphonePermissionGranted = false;
  bool _locationPermissionGranted = false;
  bool _termsAccepted = false;

  // Function to request permissions
  Future<void> _requestPermission(Permission permission, Function onGranted) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      onGranted();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission not granted!')),
      );
    }
  }

  // Handle permissions
  Future<void> _handlePermissions() async {
    if (_cameraPermissionGranted &&
        _microphonePermissionGranted &&
        _locationPermissionGranted &&
        _termsAccepted) {
      // All permissions granted and terms accepted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All permissions granted!')),
      );
      // Navigate to the main screen or proceed
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please grant all permissions and accept the terms')),
      );
    }
  }

  // Function to show the Terms & Conditions modal
  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const SingleChildScrollView(
            child: Text('Here are the terms and conditions of the app...'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _termsAccepted = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Please accept the following permissions to proceed:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            
            // Camera permission radio button
            Row(
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  groupValue: _cameraPermissionGranted,
                  onChanged: (value) async {
                    await _requestPermission(Permission.camera, () {
                      setState(() {
                        _cameraPermissionGranted = true;
                      });
                    });
                  },
                ),
                const Text('Camera Permission'),
              ],
            ),
            
            // Microphone permission radio button
            Row(
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  groupValue: _microphonePermissionGranted,
                  onChanged: (value) async {
                    await _requestPermission(Permission.microphone, () {
                      setState(() {
                        _microphonePermissionGranted = true;
                      });
                    });
                  },
                ),
                const Text('Microphone Permission'),
              ],
            ),
            
            // Location permission radio button
            Row(
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  groupValue: _locationPermissionGranted,
                  onChanged: (value) async {
                    await _requestPermission(Permission.location, () {
                      setState(() {
                        _locationPermissionGranted = true;
                      });
                    });
                  },
                ),
                const Text('Location Permission'),
              ],
            ),

            const SizedBox(height: 20),
            
            // Terms & Conditions link and radio button
            Row(
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  groupValue: _termsAccepted,
                  onChanged: (value) {
                    _showTermsAndConditions();
                  },
                ),
                const Text('Accept Terms and Conditions'),
                TextButton(
                  onPressed: _showTermsAndConditions,
                  child: const Text(
                    'Read Terms & Conditions',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),

            const Spacer(),
            
            // Accept All Button
            Center(
              child: ElevatedButton(
                onPressed: _handlePermissions,
                child: const Text('Accept All and Proceed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
