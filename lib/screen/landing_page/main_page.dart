import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../login_page/login_page.dart';
import '../tab_page/tab_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.initState();
    setAlarmStream();
  }

  setAlarmStream() {
    Alarm.ringStream.stream.listen((event) {
      debugPrint(event.notificationBody);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(event.notificationTitle.toString()),
            content: Text(event.notificationBody.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Alarm.stop(event.id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (userProvider.username != null) {
              return const TabPage();
            } else {
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}
