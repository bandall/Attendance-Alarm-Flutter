import 'package:acha/model/alarm/app_launcher.dart';
import 'package:acha/screen/component/app_bar.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmRingPage extends StatefulWidget {
  final AlarmSettings alarmSetting;

  const AlarmRingPage({Key? key, required this.alarmSetting}) : super(key: key);

  @override
  State<AlarmRingPage> createState() => _AlarmRingPageState();
}

class _AlarmRingPageState extends State<AlarmRingPage> {
  DateTime? lastPressed;

  void onConfirmPressed(BuildContext context) async {
    try {
      final delayedDateTime =
          widget.alarmSetting.dateTime.add(const Duration(days: 7));
      final delayedAlarmSettings = AlarmSettings(
        id: widget.alarmSetting.id,
        dateTime: delayedDateTime,
        assetAudioPath: widget.alarmSetting.assetAudioPath,
        loopAudio: true,
        vibrate: true,
        fadeDuration: 2.0,
        notificationTitle: widget.alarmSetting.notificationTitle,
        notificationBody: widget.alarmSetting.notificationBody,
        enableNotificationOnKill: true,
      );
      await Alarm.stop(widget.alarmSetting.id);

      if (widget.alarmSetting.notificationBody.startsWith('[수업시간]')) {
        await Alarm.set(alarmSettings: delayedAlarmSettings);
      }
      Navigator.pop(context);
      await AppLauncher().launchAjouApp();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onDelayPressed(BuildContext context) async {
    try {
      final delayedDateTime =
          widget.alarmSetting.dateTime.add(const Duration(minutes: 5));
      var reNotificationBody = widget.alarmSetting.notificationBody
          .replaceFirst('[수업시간]', '[RE:수업시간]');

      final delayedAlarmSettings = AlarmSettings(
        id: widget.alarmSetting.id,
        dateTime: delayedDateTime,
        assetAudioPath: widget.alarmSetting.assetAudioPath,
        loopAudio: true,
        vibrate: true,
        fadeDuration: 2.0,
        notificationTitle: widget.alarmSetting.notificationTitle,
        notificationBody: reNotificationBody,
        enableNotificationOnKill: true,
      );

      await Alarm.stop(widget.alarmSetting.id);
      await Alarm.set(alarmSettings: delayedAlarmSettings);
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
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
              content: const Text('알림을 종료해주세요!'),
              duration: const Duration(seconds: 2),
            ),
          );
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "출석체크 하세요!!", backButton: false),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('과목명'),
                    Text(
                      widget.alarmSetting.notificationBody,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text('수업 시간'),
                    Text(
                      "${widget.alarmSetting.dateTime.hour.toString().padLeft(2, '0')}시 ${widget.alarmSetting.dateTime.minute.toString().padLeft(2, '0')}분",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            onDelayPressed(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red, // foreground
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.timer),
                          label: const Text('5 분 뒤 알림'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            onConfirmPressed(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade700, // foreground
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text('출석체크 하기'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
