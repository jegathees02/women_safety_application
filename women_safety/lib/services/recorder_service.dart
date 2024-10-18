import 'dart:async';
import 'dart:io';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

class RecorderService {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  late CameraController _cameraController;
  bool _isRecording = false;
  

  // AWS S3 configuration loaded from .env
  late final String _bucketId;
  late final String _accessKey;
  late final String _secretKey;
  late final String _region;

  RecorderService() {
    // Load environment variables
    _bucketId =  'women-safety-application1';
    _accessKey =  'AKIAXYKJQONL2FPDSPU71';
    _secretKey =  'p9lS+sYX9UEyptX9nTXKsR1wI+/uMD6tsvfIjyTe1';
    _region =  'us-east-11';
  }

  // Initialize both audio and camera
  Future<void> initializeRecorder() async {
    // Initialize the audio recorder
    await _audioRecorder.openRecorder();

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
  Future<List<String>> startRecording() async {
    if (_isRecording) return [];

    _isRecording = true;
    // Get the temporary directory for storing the files
    // final tempDir = await getTemporaryDirectory();
    const audioPath = 'audio_recording.aac';
    const videoPath = 'video_recording.mp4';

    // Start audio recording
    await _audioRecorder.startRecorder(
      toFile: audioPath,
      codec: Codec.aacADTS,
    );

    // Start video recording
    await _cameraController.startVideoRecording(); // Removed videoPath argument here

    // Return paths for later use
    return [audioPath, videoPath];
  }

  // Stop recording and return file paths
  Future<List<String>> stopRecording() async {
    // Stop audio recording
    final audioPath = await _audioRecorder.stopRecorder();
    // Stop video recording
    final videoPath = await _cameraController.stopVideoRecording().then((value) => value.path);

    _isRecording = false;

    // Return the file paths
    return [audioPath!, videoPath]; // Assuming audioPath is non-null
  }

  // Upload file to AWS S3
  Future<void> uploadToAWS(String filePath, String fileName) async {
    final file = File(filePath);
    dotenv.load(fileName: ".env");
    if (await file.exists()) {
      // Upload the file to S3
      final result = await AwsS3.uploadFile(
        accessKey: _accessKey,
        secretKey: _secretKey,
        file: file,
        bucket: _bucketId,
        region: _region,
        metadata: {"test": "test"}, // optional
      );

      // Optionally return a success message or URI
      if (result != null) {
        print('$fileName uploaded successfully to $result');
      } else {
        print('Failed to upload $fileName.');
      }
    } else {
      throw Exception('File $filePath does not exist');
    }
  }

  // Dispose resources
  void dispose() {
    _audioRecorder.closeRecorder(); // Ensure the audio recorder is closed
    _cameraController.dispose(); // Dispose of the camera controller
  }
}
