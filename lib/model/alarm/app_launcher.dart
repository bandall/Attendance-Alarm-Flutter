import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class AppLauncher {
  Future<void> launchAjouApp() async {
    var newVariable = await LaunchApp.isAppInstalled(
        androidPackageName: 'kr.ac.ajou.mobile', iosUrlScheme: '://');
    debugPrint(newVariable.toString());
    await LaunchApp.openApp(
      androidPackageName: 'kr.ac.ajou.mobile',
      iosUrlScheme: '://',
      appStoreLink:
          'https://play.google.com/store/apps/details?id=kr.ac.ajou.mobile',
    );
  }

  Future<void> launchMyApp() async {
    var newVariable = await LaunchApp.isAppInstalled(
        androidPackageName: 'com.example.acha', iosUrlScheme: '://');
    debugPrint(newVariable.toString());
    await LaunchApp.openApp(
      androidPackageName: 'com.example.acha',
      iosUrlScheme: '://',
    );
  }
}
