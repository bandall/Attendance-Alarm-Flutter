import 'package:acha/model/alarm/alarm_controller.dart';
import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/alarm/alarm_info_db.dart';
import 'package:acha/model/api/service_api.dart';
import 'package:acha/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../component/app_bar.dart';
import '../component/assets.dart';
import 'alarm_edit_page.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({Key? key}) : super(key: key);

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  List<AlarmInfo> _alarmList = [];
  AlarmInfoDb alarmDb = AlarmInfoDb();

  final List<String> _dayList = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    _setAlarmList();
  }

  void _setAlarmList() async {
    var updatedList = await alarmDb.getAllAlarms();
    updatedList.sort((a, b) {
      if (a.day == b.day) {
        if (a.hour == b.hour) {
          return a.minute.compareTo(b.minute);
        }

        return a.hour.compareTo(b.hour);
      }

      return a.day.compareTo(b.day);
    });

    setState(() {
      _alarmList = updatedList;
    });
  }

  // 시간표 등록 함수
  void _setTimeTable(String shareUrl, UserProvider userProvider) async {
    try {
      await ServiceApi().setTimeTable(shareUrl, userProvider);
      _getAlarmsAndSetAlarmSchdule(userProvider);
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _getAlarmsAndSetAlarmSchdule(UserProvider userProvider) async {
    try {
      List<AlarmInfo> alarms = await ServiceApi().getAllAlarms(userProvider);
      await AlarmController().deleteAll();
      await alarmDb.deleteAll();

      for (var alarm in alarms) {
        await alarmDb.insert(alarm);
        if (alarm.isAlarmOn) {
          await AlarmController().setAlarm(alarm);
        }
      }

      _setAlarmList();
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _updateAlarm(int alarmId, int alarmGap, bool isAlarmOn,
      UserProvider userProvider) async {
    try {
      await alarmDb.updateAlarmOn(alarmId, isAlarmOn, alarmGap);
      AlarmInfo alarmInfo = await alarmDb.getAlarm(alarmId);
      AlarmController().updateAlarm(alarmInfo);

      await ServiceApi()
          .updateAlarm(alarmId, alarmGap, isAlarmOn, userProvider);
      _setAlarmList();
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _deleteAlarm(UserProvider userProvider) async {
    try {
      await AlarmController().deleteAll();
      await alarmDb.deleteAll();
      await ServiceApi().deleteTimetableAndAlarm(userProvider);
      _setAlarmList();
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _showAddAlarmDialog() {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알람 등록'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('알람에 사용할 URL을 입력해주세요.'),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('등록'),
              onPressed: () {
                String url = urlController.text;
                _setTimeTable(
                    url, Provider.of<UserProvider>(context, listen: false));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(title: '알림 목록'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            ListView.separated(
              itemCount: _alarmList.isEmpty ? 1 : _alarmList.length + 1,
              separatorBuilder: (context, index) {
                if (_alarmList.isEmpty) {
                  return Container();
                }

                if (index > 0 &&
                    _alarmList[index].day != _alarmList[index - 1].day) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${_dayList[_alarmList[index + 1].day]}요일",
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  );
                } else {
                  return Container(height: 5);
                }
              },
              itemBuilder: (context, index) {
                if (_alarmList.isEmpty) {
                  return const Center(child: Text("알람이 없습니다"));
                }
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${_dayList[_alarmList[0].day]}요일",
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  );
                }
                final alarmInfo = _alarmList[index - 1];
                final alarmTime =
                    DateTime(2000, 1, 1, alarmInfo.hour, alarmInfo.minute);
                final adjustedTime =
                    alarmTime.subtract(Duration(minutes: alarmInfo.alarmGap));
                final adjustedHour =
                    adjustedTime.hour.toString().padLeft(2, '0');
                final adjustedMinute =
                    adjustedTime.minute.toString().padLeft(2, '0');

                return Card(
                  color: Colors.white70,
                  child: ListTile(
                    title: Text(
                      alarmInfo.subjectName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        text: "${_dayList[alarmInfo.day]}요일 ",
                        style: const TextStyle(color: Colors.black54),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                "$adjustedHour시 $adjustedMinute분", // 시간을 alarmGap만큼 뺀 시간으로 출력
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Switch(
                      value: alarmInfo.isAlarmOn,
                      onChanged: (value) async {
                        _updateAlarm(alarmInfo.alarmId, alarmInfo.alarmGap,
                            value, userProvider);
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AlarmEditPage(alarmInfo: alarmInfo),
                        ),
                      );
                      _setAlarmList();
                    },
                  ),
                );
              },
            ),
            if (_alarmList.isEmpty) // 알람이 설정되지 않았을 때만 보여주기
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showAddAlarmDialog();
                  },
                  child: const Text('알람 등록하기'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.sync),
            label: '동기화',
            onTap: () {
              _getAlarmsAndSetAlarmSchdule(userProvider);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete),
            label: '전체 삭제',
            onTap: () async {
              _deleteAlarm(userProvider);
            },
          ),
        ],
      ),
    );
  }
}
