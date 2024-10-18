// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vibration/vibration.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:async';
// // import '../widgets/torch_widget.dart'; // Separate widget for torch functionality
// import 'package:aws_s3_client/aws_s3_client.dart'; // Use for uploading to AWS S3

// import '../widgets/button_listener.dart';

// class OnOffPage extends StatefulWidget {
//   @override
//   _OnOffPageState createState() => _OnOffPageState();
// }

// class _OnOffPageState extends State<OnOffPage> {
//   bool _isAppOn = false;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final ButtonListener _buttonListener = ButtonListener();
//   FlutterSoundRecorder? _audioRecorder;
//   CameraController? _cameraController;
//   bool _isRecording = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _buttonListener.startListening();
//     _initializeRecorder();
//   }

//   // Initialize audio and video recorder
//   Future<void> _initializeRecorder() async {
//     _audioRecorder = FlutterSoundRecorder();
//     await _audioRecorder?.openAudioSession();

//     final cameras = await availableCameras();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.high);
//     await _cameraController?.initialize();
//   }

//   // Method to start recording
//   Future<void> _startRecording() async {
//     if (!_isRecording) {
//       _isRecording = true;

//       final audioPath = '${(await getTemporaryDirectory()).path}/audio_recording.aac';
//       await _audioRecorder?.startRecorder(toFile: audioPath);

//       final videoPath = '${(await getTemporaryDirectory()).path}/video_recording.mp4';
//       await _cameraController?.startVideoRecording();

//       // Stop recording after 10 seconds
//       Timer(const Duration(seconds: 10), () async {
//         await _stopRecording(audioPath, videoPath);
//         _isRecording = false;
//       });
//     }
//   }

//   // Method to stop recording and upload to AWS S3
//   Future<void> _stopRecording(String audioPath, String videoPath) async {
//     await _audioRecorder?.stopRecorder();
//     await _cameraController?.stopVideoRecording();

//     // Upload audio and video files to S3
//     await _uploadToS3(audioPath, 'audio_recording.aac');
//     await _uploadToS3(videoPath, 'video_recording.mp4');
//   }

//   // Upload file to AWS S3
//   Future<void> _uploadToS3(String filePath, String fileName) async {
//     final bucket = Bucket('your-access-key', 'your-secret-key', 'your-bucket-name', region: 'your-region');
//     final file = File(filePath);
//     await bucket.uploadFile(fileName, file);
//   }

//   // Trigger vibration and start recording
//   Future<void> _triggerVibrationAndRecord() async {
//     Vibration.vibrate(duration: 1000);
//     await _startRecording();
//   }

//   @override
//   void dispose() {
//     _buttonListener.stopListening();
//     _audioRecorder?.closeAudioSession();
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('On/Off Page')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(_isAppOn ? Icons.power_settings_new : Icons.power_off),
//               color: _isAppOn ? Colors.green : Colors.red,
//               iconSize: 100,
//               onPressed: _toggleAppState,
//             ),
//             SizedBox(height: 20),
//             Text(_isAppOn ? 'App is Active' : 'App is Inactive'),
//           ],
//         ),
//       ),
//     );
//   }

//   // Toggle app state
//   void _toggleAppState() {
//     setState(() {
//       _isAppOn = !_isAppOn;
//     });

//     if (_isAppOn) {
//       _triggerVibrationAndRecord();
//     }
//   }
// }
