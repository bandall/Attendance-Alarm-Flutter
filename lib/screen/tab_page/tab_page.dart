import 'dart:async';

import 'package:acha/model/api/user_info_api.dart';
import 'package:acha/screen/tab_page/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../component/assets.dart';
import 'home_page.dart';
import 'main_service_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
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
  }

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
          HomePage(),
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
