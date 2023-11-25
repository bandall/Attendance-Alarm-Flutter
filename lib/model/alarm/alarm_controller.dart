import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import 'alarm_info.dart';

class AlarmController {
  Future<void> setAlarm(AlarmInfo alarmInfo) async {
    var alarmTime = getAlarmTime(alarmInfo);
    setAlarmScehduler(alarmInfo, alarmTime);
  }

  Future<void> updateAlarm(AlarmInfo alarmInfo) async {
    await Alarm.stop(alarmInfo.alarmId);
    if (alarmInfo.isAlarmOn) {
      var alarmTime = getAlarmTime(alarmInfo);
      setAlarmScehduler(alarmInfo, alarmTime);
    }
    printAlarms();
  }

  DateTime getAlarmTime(AlarmInfo alarmInfo) {
    // 현재 날짜와 시간을 가져옵니다.
    DateTime now = DateTime.now();

    // 현재 요일을 가져옵니다. 월요일은 1, 일요일은 7입니다.
    int currentDayOfWeek = now.weekday;

    // 알람이 울릴 요일까지 남은 날짜를 계산합니다.
    int daysUntilAlarm = ((alarmInfo.day + 1) - currentDayOfWeek + 7) % 7;

    // 만약 알람이 오늘 울릴 예정이고, 이미 지난 시간이라면 다음 주로 설정합니다.
    if (daysUntilAlarm == 0 &&
        now.isAfter(DateTime(
            now.year, now.month, now.day, alarmInfo.hour, alarmInfo.minute))) {
      daysUntilAlarm = 7;
    }

    // 알람이 울릴 날짜와 시간을 설정합니다.
    DateTime alarmDateTime = DateTime(now.year, now.month,
        now.day + daysUntilAlarm, alarmInfo.hour, alarmInfo.minute);

    return alarmDateTime.subtract(Duration(minutes: alarmInfo.alarmGap));
  }

  Future<void> deleteOneAlarm(int alarmId) async {
    await Alarm.stop(alarmId);
  }

  void setAlarmScehduler(AlarmInfo alarmInfo, DateTime alarmTime) async {
    final alarmSettings = AlarmSettings(
      id: alarmInfo.alarmId,
      dateTime: alarmTime,
      assetAudioPath: 'assets/long_blank.mp3',
      loopAudio: true,
      vibrate: true,
      fadeDuration: 2.0,
      notificationTitle: '출석체크 하세요!!',
      notificationBody: '[수업시간] ${alarmInfo.subjectName}',
      enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> deleteAll() async {
    await Alarm.stopAll();
  }

  void printAlarms() {
    var alarms = Alarm.getAlarms();
    debugPrint(alarms.length.toString());
    for (var alarm in alarms) {
      debugPrint(alarm.toString());
    }
  }
}
