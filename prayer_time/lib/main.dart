import 'package:flutter/material.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrayerTimesScreen(),
    );
  }
}

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  // Dhaka coordinates (Bangladesh)
  Coordinates coordinates = Coordinates(23.8103, 90.4125);
  PrayerTimes? prayerTimes;

  @override
  void initState() {
    super.initState();
    // Calculate prayer times
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() {
    PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;
    prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      locationName: 'Asia/Dhaka',
    );
    setState(() {});
  }

  String _formatTime(DateTime time) {
    // Formatting the time in 12-hour format with AM/PM
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times in Dhaka'),
        backgroundColor: Colors.teal,
      ),
      body: prayerTimes == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildPrayerTimeTile(
                    'Fajr Start Time', prayerTimes!.fajrStartTime!),
                _buildPrayerTimeTile('Sunrise Time', prayerTimes!.sunrise!),
                _buildPrayerTimeTile(
                    'Dhuhr Start Time', prayerTimes!.dhuhrStartTime!),
                _buildPrayerTimeTile(
                    'Asr Start Time', prayerTimes!.asrStartTime!),
                _buildPrayerTimeTile(
                    'Maghrib Start Time', prayerTimes!.maghribStartTime!),
                _buildPrayerTimeTile(
                    'Isha Start Time', prayerTimes!.ishaStartTime!),
              ],
            ),
    );
  }

  Widget _buildPrayerTimeTile(String prayerName, DateTime prayerTime) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(prayerName),
        subtitle:
            Text(_formatTime(prayerTime)), // Display time in 12-hour format
        leading: Icon(Icons.access_time),
      ),
    );
  }
}
