import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/alarm/alarm_info_db.dart';
import 'package:acha/provider/user_provider.dart';
import 'package:acha/screen/component/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/api/service_api.dart';

class AlarmEditPage extends StatefulWidget {
  final AlarmInfo alarmInfo;

  const AlarmEditPage({super.key, required this.alarmInfo});

  @override
  _AlarmEditPageState createState() => _AlarmEditPageState();
}

class _AlarmEditPageState extends State<AlarmEditPage> {
  late int _alarmGap;
  late bool _isAlarmOn;

  @override
  void initState() {
    super.initState();
    _alarmGap = widget.alarmInfo.alarmGap;
    _isAlarmOn = widget.alarmInfo.isAlarmOn;
  }

  void _updateAlarmOn(int alarmId, int alarmGap, bool isAlarmOn,
      UserProvider userProvider) async {
    await AlarmInfoDb().updateAlarmOn(alarmId, isAlarmOn, alarmGap);
    await ServiceApi().updateAlarm(alarmId, alarmGap, isAlarmOn, userProvider);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "알림 수정", backButton: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('과목명'), // 과목명 설명 추가
                  Text(
                    widget.alarmInfo.subjectName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text('수업 시간'), // 수업 시간 설명 추가
                  Text(
                    "${widget.alarmInfo.hour.toString().padLeft(2, '0')}시 ${widget.alarmInfo.minute.toString().padLeft(2, '0')}분",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('알림 설정'),
                value: _isAlarmOn,
                onChanged: (bool value) {
                  setState(() {
                    _isAlarmOn = value;
                  });
                },
              ),
              ListTile(
                title: const Text('수업 시간 N분 전 알림'),
                trailing:
                    Text('$_alarmGap분', style: const TextStyle(fontSize: 20)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        title: const Text(
                          '알람 간격 설정',
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                        content: TextField(
                          onChanged: (value) {
                            _alarmGap = int.parse(value);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '분단위로 알람 간격 입력',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('확인',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _updateAlarmOn(widget.alarmInfo.alarmId, _alarmGap,
                        _isAlarmOn, userProvider);
                    Navigator.pop(context);
                  },
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
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
