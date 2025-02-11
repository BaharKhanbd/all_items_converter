import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:translate_text/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TranslatorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AITranslatorApp(),
      ),
    );
  }
}

class AITranslatorApp extends StatefulWidget {
  const AITranslatorApp({super.key});

  @override
  _AITranslatorAppState createState() => _AITranslatorAppState();
}

class _AITranslatorAppState extends State<AITranslatorApp> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();

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

    // Provider-এ পাঠিয়ে দিন
    Provider.of<TranslatorProvider>(context, listen: false)
        .translateText(recognizedText.text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TranslatorProvider>(context);

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
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("স্ক্যান করা লেখা:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(provider.recognizedText,
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 20),
                        Text("অনুবাদিত লেখা:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(provider.translatedText,
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
