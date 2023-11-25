import 'package:acha/model/alarm/alarm_controller.dart';
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
    DateTime alarmTime = DateTime.now().add(const Duration(seconds: 5));

    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: alarmTime,
      assetAudioPath: 'assets/long_blank.mp3',
      loopAudio: true,
      vibrate: true,
      fadeDuration: 2.0,
      notificationTitle: '출석체크 하세요!!',
      notificationBody: '[수업시간] 수학',
      enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  void getAlarm() {
    AlarmController().printAlarms();
  }

  void delteAlarm() {
    AlarmController().deleteAll();
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
                onPressed: () {
                  setAlarm();
                },
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
                    "Set Alarm",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  getAlarm();
                },
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
                    "Get Alarm",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  delteAlarm();
                },
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
                    "Delete Alarm",
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
