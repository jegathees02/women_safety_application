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
  bool _storagePermissionGranted = false; // New storage permission variable
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  // Function to check and request all required permissions
  Future<void> _checkAndRequestPermissions() async {
    await _checkPermission(Permission.camera, (isGranted) {
      setState(() {
        _cameraPermissionGranted = isGranted;
      });
    });

    await _checkPermission(Permission.microphone, (isGranted) {
      setState(() {
        _microphonePermissionGranted = isGranted;
      });
    });

    await _checkPermission(Permission.location, (isGranted) {
      setState(() {
        _locationPermissionGranted = isGranted;
      });
    });

    await _checkPermission(Permission.storage, (isGranted) { // Check storage permission
      setState(() {
        _storagePermissionGranted = isGranted;
      });
    });
  }

  // Function to check a single permission and request if not granted
  Future<void> _checkPermission(Permission permission, Function(bool) onResult) async {
    final status = await permission.status;
    if (status.isGranted) {
      onResult(true);
    } else {
      final newStatus = await permission.request();
      onResult(newStatus.isGranted);
      if (!newStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission not granted!')),
        );
      }
    }
  }

  // Function to handle "Accept All and Proceed" button click
  Future<void> _handlePermissions() async {
    await _checkAndRequestPermissions();

    if (_cameraPermissionGranted &&
        _microphonePermissionGranted &&
        _locationPermissionGranted &&
        _storagePermissionGranted && // Check storage permission
        _termsAccepted) {
      // All permissions granted and terms accepted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All permissions granted!')),
      );
      // Proceed with navigation or other actions
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

            // Camera permission toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Camera Permission'),
                Switch(
                  value: _cameraPermissionGranted,
                  onChanged: (value) async {
                    if (!value) return; // If switching off, do nothing
                    await _checkPermission(Permission.camera, (isGranted) {
                      setState(() {
                        _cameraPermissionGranted = isGranted;
                      });
                    });
                  },
                ),
              ],
            ),

            // Microphone permission toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Microphone Permission'),
                Switch(
                  value: _microphonePermissionGranted,
                  onChanged: (value) async {
                    if (!value) return; // If switching off, do nothing
                    await _checkPermission(Permission.microphone, (isGranted) {
                      setState(() {
                        _microphonePermissionGranted = isGranted;
                      });
                    });
                  },
                ),
              ],
            ),

            // Location permission toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Location Permission'),
                Switch(
                  value: _locationPermissionGranted,
                  onChanged: (value) async {
                    if (!value) return; // If switching off, do nothing
                    await _checkPermission(Permission.location, (isGranted) {
                      setState(() {
                        _locationPermissionGranted = isGranted;
                      });
                    });
                  },
                ),
              ],
            ),

            // Storage permission toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Storage Permission'),
                Switch(
                  value: _storagePermissionGranted,
                  onChanged: (value) async {
                    if (!value) return; // If switching off, do nothing
                    await _checkPermission(Permission.storage, (isGranted) {
                      setState(() {
                        _storagePermissionGranted = isGranted;
                      });
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Terms & Conditions section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Accept Terms and Conditions'),
                Switch(
                  value: _termsAccepted,
                  onChanged: (value) {
                    if (value) _showTermsAndConditions();
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showTermsAndConditions,
                child: const Text(
                  'Read Terms & Conditions',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
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
