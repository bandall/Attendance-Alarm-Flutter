import 'package:acha/model/weekly_schedule.dart';
import 'package:acha/screen/component/app_bar.dart';
import 'package:acha/screen/popup_page/empty_time_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/api/service_api.dart';
import '../../provider/user_provider.dart';
import '../component/assets.dart';

class TimeTableJoinPage extends StatefulWidget {
  const TimeTableJoinPage({super.key});

  @override
  State<TimeTableJoinPage> createState() => _TimeTableJoinPageState();
}

class _TimeTableJoinPageState extends State<TimeTableJoinPage> {
  final List<TextEditingController> _emailControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _emailFocusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.email == null) {
      _emailControllers[0].text = "로그인 후 이용 가능합니다.";
      return;
    }

    _emailControllers[0].text = userProvider.email!;
  }

  _addEmailField() {
    setState(() {
      _emailControllers.add(TextEditingController());
      _emailFocusNodes.add(FocusNode());
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_emailFocusNodes.last);
    });
  }

  _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.email == null) {
      Assets().showErrorSnackBar(context, "로그인 후 이용 가능합니다.");
      return;
    }

    List<String> emails = [];

    for (var controller in _emailControllers) {
      if (controller.text == "") {
        Assets().showErrorSnackBar(context, "이메일를 입력해주세요.");
        return;
      }
      final email = controller.text;
      emails.add(email);
      debugPrint('Input Text: $email');
    }
    WeeklySchedule? weeklySchedule;

    try {
      Assets().showLoadingDialog(context, "공강 시간을 찾는 중입니다.");
      weeklySchedule =
          await ServiceApi().getWeeklySchedule(userProvider, emails);
    } catch (e) {
      Assets().showErrorSnackBar(context, e.toString());
      return;
    } finally {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmptyTimePage(
          schedule: weeklySchedule!,
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: _emailControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (index == 0)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '이메일를 입력해주세요',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _emailControllers[index],
                              focusNode: _emailFocusNodes[index],
                              decoration: InputDecoration(
                                labelText: 'ID ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: index == 0
                                    ? Colors.grey[200]
                                    : Colors.white,
                              ),
                              readOnly: index == 0 ? true : false,
                            ),
                          ),
                          const SizedBox(width: 8.0), // 입력칸과 박스 사이의 여백
                          Container(
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? Colors.grey
                                  : Colors.red, // 첫 번째 칸의 박스 색상을 회색으로 설정
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.white),
                              onPressed: index == 0
                                  ? null
                                  : () {
                                      setState(() {
                                        _emailControllers.removeAt(index);
                                        _emailFocusNodes.removeAt(index);
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (index == _emailControllers.length - 1)
                        ElevatedButton(
                          onPressed: _addEmailField,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add),
                              SizedBox(width: 8.0),
                              Text('이메일 추가'),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await _submit();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      '공강 시간 찾기',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '공강 시간 찾기',
        backButton: false,
      ),
      body: buildEmailField(),
    );
  }
}
