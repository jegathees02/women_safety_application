// recorder_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';

class RecorderService {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  late CameraController _cameraController;
  bool _isRecording = false;

  // Initialize both audio and camera
  Future<void> initializeRecorder() async {
    // Initialize the audio recorder
    await _audioRecorder.openAudioSession();

    // Initialize the camera
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    await _cameraController.initialize();
  }

  // Start recording both audio and video
  Future<void> startRecording() async {
    if (_isRecording) return;

    _isRecording = true;
    // Get the temporary directory for storing the files
    final tempDir = await getTemporaryDirectory();
    final audioPath = '${tempDir.path}/audio_recording.aac';
    final videoPath = '${tempDir.path}/video_recording.mp4';

    // Start audio recording
    await _audioRecorder.startRecorder(
      toFile: audioPath,
      codec: Codec.aacADTS,
    );

    // Start video recording
    await _cameraController.startVideoRecording(videoPath);

    // Stop recording after 10 seconds and upload the files
    Timer(const Duration(seconds: 10), () async {
      await stopRecording(audioPath, videoPath);
      _isRecording = false;
    });
  }

  // Stop recording and upload to AWS S3
  Future<void> stopRecording(String audioPath, String videoPath) async {
    // Stop audio recording
    await _audioRecorder.stopRecorder();

    // Stop video recording
    await _cameraController.stopVideoRecording();

    // Upload to AWS S3
    await uploadToAWS(audioPath, 'audio_recording.aac');
    await uploadToAWS(videoPath, 'video_recording.mp4');
  }

  // Upload file to AWS S3
  Future<void> uploadToAWS(String filePath, String fileName) async {
    final bucket = Bucket(
      region: 'your-region',
      bucketName: 'your-bucket-name',
      accessKey: 'your-access-key',
      secretKey: 'your-secret-key',
    );

    final file = File(filePath);
    await bucket.uploadFile(
      fileName,
      file,
      'video/mp4', // or 'audio/aac' for audio files
    );
  }

  // Dispose resources
  void dispose() {
    _audioRecorder.closeAudioSession();
    _cameraController.dispose();
  }
}
