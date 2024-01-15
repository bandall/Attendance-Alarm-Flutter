import 'package:acha/model/alarm/alarm_info_db.dart';
import 'package:acha/screen/component/app_bar.dart';
import 'package:acha/screen/component/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/api/service_api.dart';
import 'package:acha/provider/user_provider.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({super.key});

  @override
  _AddAlarmPageState createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  late TextEditingController _subjectController;
  late int _selectedDay;
  late TimeOfDay _selectedTime;
  late TextEditingController _gapController;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController();
    _selectedDay = 0;
    _selectedTime = TimeOfDay.now();
    _gapController = TextEditingController();
    _gapController.text = '0';
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _gapController.dispose();
    super.dispose();
  }

  void _saveAlarm(UserProvider userProvider) async {
    try {
      if (_subjectController.text == "") {
        Assets().showErrorSnackBar(context, "과목명을 입력해주세요.");
        return;
      }

      if (_gapController.text == "") {
        Assets().showErrorSnackBar(context, "알림 간격을 입력해주세요.");
        return;
      }

      bool isAlarmAlreadySet = await AlarmInfoDb()
          .isAlarmSet(_selectedDay, _selectedTime.hour, _selectedTime.minute);
      if (isAlarmAlreadySet) {
        Assets().showErrorSnackBar(context, "이미 같은 시간에 설정된 알림이 있습니다.");
        return;
      }

      AlarmInfo newAlarm = AlarmInfo(
        alarmId: -1,
        memberId: -1,
        subjectId: -1,
        subjectName: _subjectController.text,
        day: _selectedDay,
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
        alarmGap: int.parse(_gapController.text),
        isAlarmOn: true,
      );
      debugPrint(newAlarm.toString());
      await ServiceApi().saveAlarm(newAlarm, userProvider);
      Navigator.pop(context, true);
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final days = ['월', '화', '수', '목', '금', '토', '일'];

    return Scaffold(
      appBar: const CustomAppBar(
        title: '알람 등록',
        backButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: const Text('수업 시간', style: TextStyle(fontSize: 24)),
                trailing: Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: '과목명',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 2.0, // 각 요일 사이의 간격
                children: List.generate(7, (index) {
                  return ChoiceChip(
                    label: Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            _selectedDay == index ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: _selectedDay == index,
                    selectedColor: Colors.blue,
                    labelPadding: const EdgeInsets.all(5),
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedDay = selected ? index : 0;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _gapController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'N분 전 울림',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  _saveAlarm(userProvider);
                },
                child: const Text(
                  '알림 등록',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
