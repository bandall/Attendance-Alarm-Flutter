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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didpop) async {
        if (didpop) {
          return;
        }
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade400,
              content: const Text('앱을 종료하면 알람이 실행되지 않습니다.\n홈 버튼으로 나가주세요.'),
              duration: const Duration(seconds: 2),
            ),
          );
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
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
      ),
    );
  }
}
