import 'package:face_detection/attenance.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding/decoding the list

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final picker = ImagePicker();
  File? _image;
  TextEditingController _nameController =
      TextEditingController(); // Name Controller

  // ফেস ডিটেকশন এবং ইউজারের নাম এবং ছবি সেভ করা
  Future<void> _registerUser() async {
    if (_image != null && _nameController.text.isNotEmpty) {
      String userName =
          _nameController.text; // Get user name from the TextField

      // Save user data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the existing user list, or create an empty one if it doesn't exist
      List<String> userList = prefs.getStringList('userList') ?? [];
      print(userList);
      // Convert image path to JSON string (can be a better structure)
      String userData = json.encode({
        'name': userName,
        'imagePath': _image!.path,
      });

      // Add new user data to the list
      userList.add(userData);

      // Save the updated list back to SharedPreferences
      await prefs.setStringList('userList', userList);

      // Registration successful message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Registered Successfully')));

      // Navigate to Attendance Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AttendancePage()),
      );
    } else {
      // Show error if the image or name is empty
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter name and pick an image')));
    }
  }

  // Pick an image for registration
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
      appBar: AppBar(title: Text('User Registration')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _nameController, // Name input field
              decoration: InputDecoration(labelText: 'Enter Employee Name'),
            ),
            _image == null ? Text('No Image Selected') : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
