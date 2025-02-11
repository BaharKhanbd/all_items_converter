import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AITranslatorApp(),
    );
  }
}

class AITranslatorApp extends StatefulWidget {
  @override
  _AITranslatorAppState createState() => _AITranslatorAppState();
}

class _AITranslatorAppState extends State<AITranslatorApp> {
  File? _image;
  String _recognizedText = "";
  String _translatedText = "";
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();
  final onDeviceTranslator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.english,
    targetLanguage: TranslateLanguage.bengali,
  );

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
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedText = recognizedText.text;
    });
    _translateText(_recognizedText);
  }

  Future<void> _translateText(String text) async {
    final translated = await onDeviceTranslator.translateText(text);
    setState(() {
      _translatedText = translated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("এআই-চালিত অনুবাদক")),
      body: Column(
        children: [
          SizedBox(height: 20),
          _image != null
              ? Image.file(_image!, height: 200)
              : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text("কোনও ছবি নির্বাচিত হয়নি"))),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text("গ্যালারি থেকে নির্বাচন করুন"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text("ছবি তুলুন"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("স্ক্যান করা লেখা:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(_recognizedText, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text("অনুবাদিত লেখা:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(_translatedText,
                      style: TextStyle(fontSize: 16, color: Colors.blue)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
