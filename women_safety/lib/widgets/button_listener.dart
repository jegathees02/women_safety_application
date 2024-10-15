import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
// import 'package:flutter_volume_controller/flutter_volume_button.dart';
import 'package:vibration/vibration.dart';

class ButtonListener {
  Timer? _timer;
  bool _isListening = false;
  bool _isVolumeUpPressed = false;

  // Start listening for volume button presses
  void startListening() {
    if (_isListening) return; // Prevent multiple listeners

    _isListening = true;

    // Listening for volume button presses
    FlutterVolumeController.addListener((volume) {
      // print('Volume: $volume'); volume in range 0.1 to 1.0
      if (volume > 0.5) {
        _isVolumeUpPressed = true;
        _startTimer(); // Start timer immediately when volume up is pressed
      } else if (volume <= 0.5) {
        _isVolumeUpPressed = false;
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
        // }
      }
    });
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
  }
}