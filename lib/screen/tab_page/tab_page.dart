import 'dart:async';

import 'package:acha/model/api/user_info_api.dart';
import 'package:acha/screen/tab_page/alarm_list_page.dart';
import 'package:acha/screen/tab_page/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../component/assets.dart';
import 'main_service_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late bool _isTableSetted;
  late String tableId;
  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.account_circle), text: 'Main Service'),
    Tab(icon: Icon(Icons.person), text: 'User Info'),
  ];

  late TabController _tabController;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      try {
        await UserInfoApi().getUserInfo(userProvider);
      } on TimeoutException catch (e) {
        Assets().showErrorSnackBar(context, e.message);
      } catch (e) {
        return;
      }
    });
    // initTable();
  }

  // void initTable() async {
  //   var tableId = await _storage.read(key: 'tableId');
  //   if (tableId == null) {
  //     _isTableSetted = false;
  //     debugPrint('isTableSetted: $_isTableSetted');
  //     _showTableIDInputDialog();
  //     return;
  //   }
  //   _isTableSetted = true;
  //   debugPrint('isTableSetted: $_isTableSetted');
  // }

  // void _showTableIDInputDialog() {
  //   TextEditingController controller = TextEditingController();
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // user must tap button to dismiss dialog!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //         title: const Text(
  //           '시간표 설정하기',
  //           style: TextStyle(color: Colors.blueGrey, fontSize: 24),
  //         ),
  //         content: TextField(
  //           controller: controller,
  //           keyboardType: TextInputType.text,
  //           decoration: InputDecoration(
  //             hintText: '시간표 공유 URL을 입력해주세요.',
  //             hintStyle: const TextStyle(color: Colors.grey),
  //             filled: true,
  //             fillColor: Colors.blueGrey.shade50,
  //             enabledBorder: const OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(12.0)),
  //               borderSide: BorderSide(color: Colors.blueGrey, width: 2),
  //             ),
  //             focusedBorder: const OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //               borderSide: BorderSide(color: Colors.blueGrey),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('알람 설정하기',
  //                 style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
  //             onPressed: () {
  //               Navigator.of(context).pop(controller.text);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null) {
  //       _storage.write(key: 'tableId', value: value);
  //     }
  //   });
  // }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: const [
          AlarmListPage(),
          MainServicePage(),
          UserInfoPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade400,
              width: 1.0,
            ),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey.shade400,
          tabs: _tabs,
        ),
      ),
    );
  }
}
