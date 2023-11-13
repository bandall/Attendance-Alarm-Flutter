import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class AppLauncher {
  Future<void> launchApp() async {
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
}
