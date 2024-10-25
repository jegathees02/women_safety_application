import 'dart:async';
import 'package:flutter/material.dart';
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

  String? _audioPath; // Store audio path
  String? _videoPath; // Store video path

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
          // Send an alert to the backend
          SendAlert();
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
