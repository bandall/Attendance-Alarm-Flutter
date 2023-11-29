import 'package:acha/model/alarm/alarm_controller.dart';
import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/alarm/alarm_info_db.dart';
import 'package:acha/screen/component/assets.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../component/app_bar.dart';

class MainServicePage extends StatefulWidget {
  const MainServicePage({Key? key}) : super(key: key);

  @override
  _MainServicePageState createState() => _MainServicePageState();
}

class _MainServicePageState extends State<MainServicePage> {
  List<AlarmSettings>? alarms;
  List<AlarmInfo>? alarmsInDb;

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

  void getDbAlarm() async {
    alarmsInDb = await AlarmInfoDb().getAllAlarms();
    alarms = null;
    setState(() {});
  }

  void getAlarm() async {
    alarms = Alarm.getAlarms();
    alarmsInDb = null;
    setState(() {});
  }

  void deleteAlarm() async {
    await AlarmController().deleteAll();
    Assets().showSnackBar(context, '삭제완료!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Main Service'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
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
            ElevatedButton(
              onPressed: () {
                getDbAlarm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Text(
                  "Db AlarmInfo",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Text(
                  "Get Alarm",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                deleteAlarm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Text(
                  "Delete Alarm",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            alarms != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: alarms?.length ?? 0,
                      itemBuilder: (context, index) {
                        final alarm = alarms![index];
                        return ListTile(
                          title: Text('Alarm ${index + 1}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Day: ${alarm.dateTime.weekday - 1}'),
                              Text(
                                  'Time: ${alarm.dateTime.hour}:${alarm.dateTime.minute}'),
                              Text('Subject Name: ${alarm.notificationBody}'),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: alarmsInDb?.length ?? 0,
                      itemBuilder: (context, index) {
                        final alarm = alarmsInDb![index];
                        return ListTile(
                          title: Text('Alarm ${index + 1}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time: ${alarm.hour}:${alarm.minute}'),
                              Text('Day: ${alarm.day}'),
                              Text('Alarm Gap: ${alarm.alarmGap}'),
                              Text(
                                  'Is Alarm On: ${alarm.isAlarmOn ? "Yes" : "No"}'),
                              Text('Subject ID: ${alarm.subjectId}'),
                              Text('Subject Name: ${alarm.subjectName}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
