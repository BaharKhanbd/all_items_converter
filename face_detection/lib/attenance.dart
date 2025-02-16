import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding/decoding the list

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final picker = ImagePicker();
  File? _image;
  final FaceDetector faceDetector = FaceDetector(
    options:
        FaceDetectorOptions(enableContours: true, enableClassification: true),
  );
  String _attendanceStatus = '';
  String _employeeName = '';

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
  }

  // Check face and match with registered users
  Future<void> _checkAttendance() async {
    if (_image != null) {
      final inputImage = InputImage.fromFile(_image!);

      try {
        final faces = await faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          // Debugging: Print the number of faces detected
          print('Number of faces detected: ${faces.length}');

          // Retrieve the user list from SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> userList = prefs.getStringList('userList') ?? [];
          print(userList);
          bool isUserMatched = false;

          // Iterate over the stored user list and check for a match
          for (String userData in userList) {
            Map<String, dynamic> user = json.decode(userData);

            // Debugging: Print the image path comparison
            print('Comparing: ${_image!.path} with ${user['imagePath']}');

            // Compare the image paths for simplicity (better method needed for face recognition)
            if (_image!.path == user['imagePath']) {
              setState(() {
                _employeeName = user['name']; // Store the matched user's name
                _attendanceStatus = 'Attendance OK';
              });
              isUserMatched = true;
              break;
            }
          }

          // If no match found
          if (!isUserMatched) {
            setState(() {
              _attendanceStatus = 'Face not recognized...';
            });
          }
        } else {
          setState(() {
            _attendanceStatus = 'No Face Detected***';
          });
        }
      } catch (e) {
        print('Error in face detection: $e');
        setState(() {
          _attendanceStatus = 'Face detection failed///';
        });
      }
    }
  }

  // Pick an image for attendance check
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
              SizedBox(height: 10),
              if (_attendanceStatus == 'Attendance OK')
                Text(
                  'Employee: $_employeeName',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
