import 'package:acha/model/alarm/alarm_controller.dart';
import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/alarm/alarm_info_db.dart';
import 'package:acha/model/api/service_api.dart';
import 'package:acha/provider/user_provider.dart';
import 'package:acha/screen/alarm_page/new_alarm_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../component/app_bar.dart';
import '../component/assets.dart';
import '../alarm_page/alarm_edit_page.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({Key? key}) : super(key: key);

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

// 시간표 등록 안되어 있으면 알림 추가 못하게 하기
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

    if (mounted) {
      setState(() {
        _alarmList = updatedList;
      });
    }
  }

  // 시간표 등록 함수
  void _setTimeTable(String shareUrl, UserProvider userProvider) async {
    Assets().showLoadingDialog(context, "등록 중..");
    try {
      _checkLogin(userProvider);
      await ServiceApi().setTimeTable(shareUrl, userProvider);
      _getAlarmsAndSetAlarmSchdule(userProvider);
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  void _getAlarmsAndSetAlarmSchdule(UserProvider userProvider) async {
    try {
      _checkLogin(userProvider);
      List<AlarmInfo> alarms = await ServiceApi().getAllAlarms(userProvider);
      await AlarmController().deleteAll();
      await alarmDb.deleteAll();

      for (var alarm in alarms) {
        await alarmDb.insert(alarm);
        if (alarm.isAlarmOn) {
          await AlarmController().setAlarm(alarm);
        }
      }

      AlarmController().printAlarms();

      _setAlarmList();
      Assets().showSnackBar(context, '동기화 완료');
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _addNewAlarm(UserProvider userProvider) async {
    try {
      _checkLogin(userProvider);

      var isAdded =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const AddAlarmPage();
      }));

      if (isAdded == null || isAdded == false) {
        return;
      }
      _getAlarmsAndSetAlarmSchdule(userProvider);
      Assets().showSnackBar(context, '알람 추가 완료');
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _updateAlarm(int alarmId, int alarmGap, bool isAlarmOn,
      UserProvider userProvider) async {
    try {
      _checkLogin(userProvider);
      await alarmDb.updateAlarmOn(alarmId, isAlarmOn, alarmGap);
      AlarmInfo alarmInfo = await alarmDb.getAlarm(alarmId);
      AlarmController().updateAlarm(alarmInfo);

      ServiceApi().updateAlarm(alarmId, alarmGap, isAlarmOn, userProvider);
      _setAlarmList();
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _deleteAllAlarm(UserProvider userProvider) async {
    try {
      _checkLogin(userProvider);
      await AlarmController().deleteAll();
      await alarmDb.deleteAll();
      ServiceApi().deleteTimetableAndAlarm(userProvider);
      _setAlarmList();
      Assets().showSnackBar(context, '전체 삭제 되었습니다.');
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  void _checkLogin(UserProvider userProvider) {
    if (userProvider.username == null) {
      throw Exception('로그인이 필요합니다.');
    }
  }

  void _showAddAlarmDialog() {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림 등록'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('알림에 사용할 URL을 입력해주세요.'),
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
                Navigator.of(context).pop();
                _setTimeTable(
                    url, Provider.of<UserProvider>(context, listen: false));
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
                      "${_dayList[_alarmList[index].day]}요일",
                      style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  );
                } else {
                  return Container(height: 4);
                }
              },
              itemBuilder: (context, index) {
                if (_alarmList.isEmpty) {
                  return const Center(
                    child: Text(
                      "",
                      style: TextStyle(
                        fontSize: 20.0, // 텍스트 크기
                        color: Colors.black87, // 텍스트 색상
                        fontWeight: FontWeight.w500, // 텍스트 가중치
                        letterSpacing: 0.5, // 문자 간 거리
                      ),
                    ),
                  );
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
                  color: Colors.blueGrey[50],
                  elevation: 1.0,
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
            if (_alarmList.isEmpty)
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "알림이 없습니다", // 텍스트 내용
                    style: TextStyle(
                      fontSize: 24.0, // 텍스트 크기
                      color: Colors.black87, // 텍스트 색상
                      fontWeight: FontWeight.w500, // 텍스트 가중치
                      letterSpacing: 0.5, // 문자 간 거리
                    ),
                  ),
                  const SizedBox(height: 20), // 텍스트와 버튼 사이의 간격
                  ElevatedButton.icon(
                    onPressed: () {
                      try {
                        _checkLogin(userProvider);
                        _showAddAlarmDialog();
                      } catch (e) {
                        Assets().showErrorSnackBar(context, e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // 아이콘 및 레이블 색상
                      minimumSize: const Size(200, 50), // 버튼 크기
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                      ),
                    ),
                    icon: const Icon(Icons.alarm_add), // 아이콘
                    label: const Text(
                      '에브리타임으로 일괄 등록하기', // 레이블 텍스트
                      style: TextStyle(
                        fontSize: 18, // 텍스트 크기
                      ),
                    ),
                  ),
                ],
              )),
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
              _deleteAllAlarm(userProvider);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: '알림 추가',
            onTap: () async {
              _addNewAlarm(userProvider);
            },
          ),
        ],
      ),
    );
  }
}
