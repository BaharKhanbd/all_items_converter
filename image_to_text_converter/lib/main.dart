import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TextRecognitionScreen(),
    );
  }
}

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({super.key});

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  File? _image;
  String _recognizedText = "";
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _scanText();
    }
  }

  Future<void> _scanText() async {
    if (_image == null) return;
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedText = recognizedText.text;
    });
    textRecognizer.close();
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _recognizedText));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Text Copied!")));
  }

  void _shareText() {
    Share.share(_recognizedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Recognition")),
      body: Column(
        children: [
          SizedBox(height: 20),
          _image != null
              ? Image.file(_image!, height: 200)
              : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text("No Image Selected"))),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text("Pick from Gallery"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text("Take a Photo"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _copyText,
                child: Text("Copy Text"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _shareText,
                child: Text("Share Text"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(_recognizedText, style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
