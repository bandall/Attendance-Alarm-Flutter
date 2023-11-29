import 'dart:io';

import 'package:acha/provider/user_provider.dart';
import 'package:acha/screen/landing_page/main_page.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Alarm.init(showDebugLogs: false);

  PermissionStatus notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    await Permission.notification.request();
  }

  PermissionStatus batteryStatus =
      await Permission.ignoreBatteryOptimizations.status;
  debugPrint(batteryStatus.toString());
  if (!batteryStatus.isGranted) {
    await Permission.ignoreBatteryOptimizations.request();
  }

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerPeriodicTask(
  //   "set_alarm_for_week",
  //   "alarm_background_task",
  //   frequency: const Duration(minutes: 15),
  //   tag: "alarm_background_task",
  //   existingWorkPolicy: ExistingWorkPolicy.keep,
  // );

  // Workmanager().registerPeriodicTask(
  //   "set_alarm_for_week",
  //   "alarm_background_task",
  //   frequency: const Duration(days: 7),
  //   initialDelay: getDurationUntilMonday(),
  //   tag: "alarm_background_task",
  //   existingWorkPolicy: ExistingWorkPolicy.keep,
  // );
  // Workmanager().cancelAll();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Cha Cha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 17, 0, 255),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Native called background task: $task");
//     try {
//       await AlarmController().setAlarmForWeek();
//     } catch (e) {
//       print(e.toString());
//     }
//     return Future.value(true);
//   });
// }

// Duration getDurationUntilMonday() {
//   int day = DateTime.monday -
//       DateTime.now().weekday +
//       (DateTime.now().weekday > DateTime.monday ? 7 : 0);
//   int hour = 24 - DateTime.now().hour;
//   int minute = 60 - DateTime.now().minute;
//   return Duration(days: day, hours: hour, minutes: minute);
// }
