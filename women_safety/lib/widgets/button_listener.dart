import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:vibration/vibration.dart';
import 'package:women_safety/services/send_alert.dart';
import '../services/recorder_service.dart'; // Import the RecorderService

class ButtonListener {
  Timer? _timer;
  bool _isListening = false;
  bool _isVolumeUpPressed = false;
  bool _isBlinking = false;
  final RecorderService _recorderService = RecorderService(); // Instantiate RecorderService
  // final SendAlert _sendAlert = SendAlert(); // Instantiate SendAlert

  String? _audioPath; // Store audio path
  String? _videoPath; // Store video path

  Future<File?> createLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_app_log.txt');

    try {
      await file.create(recursive: true);
      return file;
    } catch (e) {
      print('Error creating log file: $e');
      return null;
    }
  }

  Future<void> logToTextFile(String message) async {
    final file = await createLogFile();

    if (file != null) {
      try {
        await file.writeAsString(message + '\n', mode: FileMode.append);
      } catch (e) {
        print('Error writing to log file: $e');
      }
    }
  }

  // Start listening for volume button presses
  void startListening() async {
    if (_isListening) return; // Prevent multiple listeners

    _isListening = true;
    _isBlinking = true;

    bool isFirst = true;
    // Listening for volume button presses
    FlutterVolumeController.addListener((volume) {
      if(isFirst) {
        isFirst = false;
        FlutterVolumeController.setVolume(0.5);
      }
      if (volume >= 1.0) {
        _isVolumeUpPressed = true;
        _startTimer(); // Start timer immediately when volume up is pressed
      } else if (volume <= 0.5) {
        _isVolumeUpPressed = false;
        FlutterVolumeController.setVolume(0.5);
        _resetTimer(); // Reset timer if volume up is released
      }
    });
  }

  // Start a timer for 5 seconds
  void _startTimer() {
    _resetTimer(); // Reset any existing timer
    _timer = Timer(const Duration(seconds: 5), () async {
      if (_isVolumeUpPressed) {
        // Check if the device has a vibrator and vibrate
        // if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 1000); // Vibrate for 1 second
          logToTextFile("Vibration done");
          // Send an alert to the backend
            try {
              await sendAlert();
              logToTextFile("Alert sent successfully.");
            } catch (e) {
              logToTextFile("Error occurred while sending alert: $e");
            }

          FlutterVolumeController.setVolume(0.5);
          // Initialize the recorder service
          await _recorderService.initializeRecorder();
          // Start recording audio and video
          List<String> paths = await _recorderService.startRecording();
          _audioPath = paths[0];
          _videoPath = paths[1];

          // Wait for 10 seconds while recording
          await Future.delayed(const Duration(seconds: 10));

          // Stop recording and upload to AWS S3
          await _stopRecording();
        // }
      }
    });
  }

  // Stop recording and upload to AWS S3
  Future<void> _stopRecording() async {
    if (_audioPath != null && _videoPath != null) {
      List<String> paths = await _recorderService.stopRecording();
      print("Audio Path: ${paths[0]}, Video Path: ${paths[1]}");

      // Upload the audio and video files to AWS S3
      await _recorderService.uploadToAWS(paths[0], 'audio_recording.aac');
      await _recorderService.uploadToAWS(paths[1], 'video_recording.mp4');
    }
  }


  Future<void> sendAlert() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone_0') ?? ''; // Get the first phone number
    final email = prefs.getString('email_0') ?? ''; // Get the first email
    final token = prefs.getString('auth_token') ?? ''; // Get the token

    logToTextFile("Phone: $phone, Email: $email, Token: $token");
    print("Phone: $phone, Email: $email, Token: $token");

    if (phone.isEmpty || email.isEmpty ) {
      print("Required data is missing.");
      return;
    }


    try {

      final response = await http.post(
        Uri.parse('http://192.168.204.4:3000/alert'), // Replace with your server URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'email': email,
        }),
      );

      logToTextFile(response.body);
      print(response.body);
      // Check the response status
      if (response.statusCode == 200) {
        print("Alert sent successfully.");
      } else {
        print("Failed to send alert. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while sending alert: $e");
    }
  }

  // Reset the timer
  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Stop listening
  void stopListening() {
    _resetTimer();
    _isListening = false;
    _isBlinking = false;
  }
}
