import 'package:acha/screen/tab_page/alarm_list_page.dart';
import 'package:acha/screen/tab_page/timetable_join_page.dart';
import 'package:acha/screen/tab_page/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../popup_page/login_page.dart';
import 'main_service_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  final List<Tab> _tabs = [
    const Tab(
        icon: Icon(Icons.timer_sharp, size: 25),
        child: Text('알림', style: TextStyle(fontSize: 15))),
    const Tab(
        icon: Icon(Icons.view_timeline, size: 25),
        child: Text('공강', style: TextStyle(fontSize: 15))),
    const Tab(
        icon: Icon(Icons.person, size: 25),
        child: Text('유저 정보', style: TextStyle(fontSize: 15))),
    // Tab(icon: Icon(Icons.handyman, size: 30), child: Text('테스트', style: TextStyle(fontSize: 18))),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.username == null) {
        _tabController.index = 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: [
          const AlarmListPage(),
          const TimeTableJoinPage(),
          userProvider.username != null
              ? const UserInfoPage()
              : const LoginPage(),
          // const MainServicePage(),
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
