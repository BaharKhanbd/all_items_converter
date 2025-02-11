import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BarcodeScannerScreen(),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  File? _image;
  String _scannedData = "";
  final ImagePicker _picker = ImagePicker();
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _scanBarcode();
    }
  }

  Future<void> _scanBarcode() async {
    if (_image == null) return;
    final inputImage = InputImage.fromFile(_image!);
    final List<Barcode> barcodes =
        await _barcodeScanner.processImage(inputImage);

    setState(() {
      _scannedData = barcodes.isNotEmpty
          ? barcodes.first.rawValue ?? "No Data Found"
          : "No Barcode Detected";
    });
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _scannedData));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Text Copied!")));
  }

  void _shareText() {
    Share.share(_scannedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barcode & QR Code Scanner")),
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
              child: Text(_scannedData, style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
