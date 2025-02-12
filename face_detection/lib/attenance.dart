import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final picker = ImagePicker();
  File? _image;
  final FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableContours: true, enableClassification: true));
  String _attendanceStatus = '';

  @override
  void initState() {
    super.initState();
  }

  // ছবি নিয়ে ফেস ডিটেকশন চালানো
  Future<void> _checkAttendance() async {
    if (_image != null) {
      final inputImage = InputImage.fromFile(_image!);
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        // ফেস ডিটেকশন সফল হলে উপস্থিতি গ্রহণ
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? registeredUser = prefs.getString('userName');

        if (registeredUser != null) {
          setState(() {
            _attendanceStatus = '$registeredUser Attendance Marked';
          });
        }
      } else {
        setState(() {
          _attendanceStatus = 'No Face Detected';
        });
      }
    }
  }

  // ছবি তোলা
  Future<void> _pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera); // Corrected method
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Attendance')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null ? Text('No Image Selected') : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image for Attendance'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAttendance,
                child: Text('Check Attendance'),
              ),
              SizedBox(height: 20),
              Text(
                _attendanceStatus.isEmpty
                    ? 'Status will be shown here'
                    : _attendanceStatus,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
