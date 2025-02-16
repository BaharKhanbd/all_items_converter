import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SilentModeToggle(),
    );
  }
}

class SilentModeToggle extends StatefulWidget {
  const SilentModeToggle({super.key});

  @override
  _SilentModeToggleState createState() => _SilentModeToggleState();
}

class _SilentModeToggleState extends State<SilentModeToggle> {
  bool isSilent = false;
  static const platform = MethodChannel('com.example.silent_mode');

  void toggleSilentMode(bool value) async {
    try {
      await platform.invokeMethod('toggleSilentMode');
      setState(() {
        isSilent = value;
      });
    } on PlatformException catch (e) {
      if (e.code == "NO_PERMISSION") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please allow Do Not Disturb access in settings."),
            action: SnackBarAction(
              label: 'OPEN SETTINGS',
              onPressed: () {
                platform.invokeMethod('requestPermission');
              },
            ),
          ),
        );
      } else {
        print("Failed to toggle silent mode: '${e.message}'");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Silent Mode Toggle')),
      body: Center(
        child: SwitchListTile(
          title: Text('Silent Mode'),
          value: isSilent,
          onChanged: toggleSilentMode,
        ),
      ),
    );
  }
}
