import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/button_listener.dart';

class OnOffPage extends StatefulWidget {
  @override
  _OnOffPageState createState() => _OnOffPageState();
}

class _OnOffPageState extends State<OnOffPage> {
  bool _isAppOn = false;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ButtonListener _buttonListener = ButtonListener();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _createNotificationChannel(); // Create the notification channel
    _buttonListener.startListening();
  }

  // Initialize notifications
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Create notification channel
  void _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'safety_alerts', // Channel ID
      'Women Safety Alerts', // Channel Name
      description: 'Channel for Women Safety Alerts',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show a notification
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'safety_alerts', // Channel ID
      'Women Safety Alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0,
      'App is Active',
      'The Women Safety App is currently active.',
      platformChannelSpecifics,
    );

    // Trigger vibration
    await _triggerVibration();
  }

  // Cancel the notification
  Future<void> _cancelNotification() async {
    await _localNotificationsPlugin.cancel(0);
  }

  // Trigger vibration if permission is granted
  Future<void> _triggerVibration() async {
    // if (await Permission.vibration.request().isGranted) {
      // Check if the device has vibration capability
      // if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 1000); // Vibrate for 1 second
      // }
    // }
  }

  // Toggle the app state
  void _toggleAppState() {
    setState(() {
      _isAppOn = !_isAppOn;
    });

    try {
      if (_isAppOn) {
        _showNotification();
        _buttonListener.startListening(); // Start the button listener
      } else {
        _cancelNotification();
        _buttonListener.stopListening(); // Stop the button listener
      }
    } catch (e) {
      // Handle the error here, e.g., logging it or showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle notification: $e')),
      );
    }
  }

  @override
  void dispose() {
    _buttonListener.stopListening(); // Ensure listener is stopped
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On/Off Switch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Standby icon toggle button
            IconButton(
              icon: Icon(
                _isAppOn ? Icons.power_settings_new : Icons.power_off,
                color: _isAppOn ? Colors.green : Colors.red,
                size: 100,
              ),
              onPressed: _toggleAppState,
            ),
            const SizedBox(height: 20),
            Text(
              _isAppOn ? 'WS-911 READY TO DETECT' : 'TURN ON WS-911',
              style: TextStyle(
                fontSize: 24,
                color: _isAppOn ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
