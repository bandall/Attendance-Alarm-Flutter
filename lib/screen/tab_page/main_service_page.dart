import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../component/app_bar.dart';

class MainServicePage extends StatefulWidget {
  const MainServicePage({Key? key}) : super(key: key);

  @override
  _MainServicePageState createState() => _MainServicePageState();
}

class _MainServicePageState extends State<MainServicePage> {
  void setAlarm() async {
    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: DateTime.now().add(const Duration(seconds: 5)),
      assetAudioPath: 'assets/pony.mp3',
      loopAudio: true,
      vibrate: true,
      volumeMax: false,
      fadeDuration: 2.0,
      notificationTitle: '출석체크 하세요!!',
      notificationBody: '[수업시간] 데이터베이스',
      enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Main Service'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction,
                size: 60,
                color: Colors.black87,
              ),
              const SizedBox(height: 16),
              const Text(
                '메인 서비스 개발 예정',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Main service will be available soon!',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: setAlarm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    "Stay Updated",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
