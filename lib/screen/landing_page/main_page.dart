import 'dart:io';

import 'package:acha/model/alarm/app_launcher.dart';
import 'package:acha/screen/alarm_page/alarm_ring_page.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../tab_page/tab_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.initState();
    setAlarmStream();
  }

  setAlarmStream() {
    Alarm.ringStream.stream.listen((alarmSetting) async {
      await AppLauncher().launchMyApp();
      sleep(const Duration(milliseconds: 500));

      try {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AlarmRingPage(alarmSetting: alarmSetting);
        }));
      } catch (e) {
        debugPrint(e.toString());
      }
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
            return const TabPage();
          }
        },
      ),
    );
  }
}
