import 'package:acha/model/alarm/app_launcher.dart';
import 'package:acha/screen/component/app_bar.dart';
import 'package:acha/screen/landing_page/main_page.dart';
import 'package:acha/screen/tab_page/tab_page.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmRingPage extends StatelessWidget {
  final AlarmSettings event;

  const AlarmRingPage({super.key, required this.event});

  void onConfirmPressed(BuildContext context) async {
    final alarmSettings = AlarmSettings(
      id: event.id,
      dateTime: event.dateTime.add(const Duration(days: 7)),
      assetAudioPath: event.assetAudioPath,
      loopAudio: true,
      vibrate: false,
      volumeMax: false,
      fadeDuration: 2.0,
      notificationTitle: event.notificationTitle,
      notificationBody: event.notificationBody,
      enableNotificationOnKill: true,
      stopOnNotificationOpen: false,
    );

    await Alarm.stop(event.id);
    await Alarm.set(alarmSettings: alarmSettings);
    await AppLauncher().launchApp();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: event.notificationTitle!,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  const Text('과목명'), // 과목명 설명 추가
                  Text(
                    event.notificationBody!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onConfirmPressed(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey, // foreground
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('출석체크 하러가기'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onConfirmPressed(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey, // foreground
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('5분 뒤로 미루기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
