import 'package:acha/model/alarm/app_launcher.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../login_page/login_page.dart';
import '../tab_page/tab_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.initState();
    setAlarmStream();
  }

  setAlarmStream() {
    Alarm.ringStream.stream.listen((event) async {
      debugPrint(event.toString());
      var alarmTime = event.dateTime;

      final alarmSettings = AlarmSettings(
        id: event.id,
        dateTime: alarmTime.add(const Duration(days: 7)),
        assetAudioPath: event.assetAudioPath,
        loopAudio: true,
        vibrate: true,
        volumeMax: false,
        fadeDuration: 2.0,
        notificationTitle: event.notificationTitle,
        notificationBody: event.notificationBody,
        enableNotificationOnKill: true,
        stopOnNotificationOpen: false,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(event.notificationTitle.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 24)),
            content: Text(event.notificationBody.toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 18)),
            actions: <Widget>[
              TextButton(
                child: const Text('확인',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                onPressed: () async {
                  await Alarm.stop(event.id);
                  await Alarm.set(alarmSettings: alarmSettings);
                  Navigator.of(context).pop();
                  await AppLauncher().launchApp();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (userProvider.username != null) {
              return const TabPage();
            } else {
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}
