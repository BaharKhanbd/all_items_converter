import 'package:face_detection/attenance.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final picker = ImagePicker();
  File? _image;

  // ফেস ডিটেকশন এবং ইউজারের নাম এবং ছবি সেভ করা
  Future<void> _registerUser() async {
    if (_image != null) {
      // ইউজারের নাম নেওয়া
      String userName =
          "Employee Name"; // এখানেই আপনি ইউজারের নাম নিতে পারেন (text field ব্যবহার করতে পারেন)

      // SharedPreferences এ সেভ করা
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      await prefs.setString('userImage', _image!.path);

      // রেজিস্ট্রেশন সফল
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Registered Successfully')));

      // রেজিস্ট্রেশন সফল হলে অ্যাটেনডেন্স পেজে নেভিগেট
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AttendancePage()),
      );
    }
  }

  // ছবি তোলা
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera); // getImage() -> pickImage()
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
