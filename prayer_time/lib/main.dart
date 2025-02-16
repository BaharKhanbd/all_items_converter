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
  // ignore: library_private_types_in_public_api
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

  final now = DateTime.now();
  void _calculatePrayerTimes() {
    PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;
    prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      dateTime: now,
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
        title: Text('Prayer Times in ${prayerTimes?.locationName}'),
        backgroundColor: Colors.teal,
      ),
      body: prayerTimes == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildPrayerTimeTile(
                    'Fajr Start Time',
                    prayerTimes!.fajrStartTime!,
                    prayerTimes!.fajrEndTime ?? DateTime.now()),
                _buildPrayerTimeTile('Sunrise Time', prayerTimes!.sunrise!,
                    prayerTimes!.sunrise ?? DateTime.now()),
                _buildPrayerTimeTile(
                    'Dhuhr Start Time',
                    prayerTimes!.dhuhrStartTime!,
                    prayerTimes!.dhuhrEndTime ?? DateTime.now()),
                _buildPrayerTimeTile(
                    'Asr Start Time',
                    prayerTimes!.asrStartTime!,
                    prayerTimes!.asrEndTime ?? DateTime.now()),
                _buildPrayerTimeTile(
                    'Maghrib Start Time',
                    prayerTimes!.maghribStartTime!,
                    prayerTimes!.maghribEndTime ?? DateTime.now()),
                _buildPrayerTimeTile(
                    'Isha Start Time',
                    prayerTimes!.ishaStartTime!,
                    prayerTimes!.ishaEndTime ?? DateTime.now()),
                _buildPrayerTimeTile(
                    'tahajjudEndTime Time',
                    prayerTimes!.tahajjudEndTime!,
                    prayerTimes!.tahajjudEndTime ?? DateTime.now()),
                _buildPrayerTimeTile('Sehri Time', prayerTimes!.sehri!,
                    prayerTimes!.sehri ?? DateTime.now()),
              ],
            ),
    );
  }

  Widget _buildPrayerTimeTile(
      String prayerName, DateTime prayerStartTime, DateTime prayerEndTime) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(prayerName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start: ${_formatTime(prayerStartTime)}'),
            Text('End: ${_formatTime(prayerEndTime)}'),
          ],
        ),
        leading: Icon(Icons.access_time),
      ),
    );
  }
}
