import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  launchApp() async {
    Uri appScheme =
        Uri.parse('intent://#Intent;package=kr.ac.ajou.mobile;scheme=;end');

    if (await canLaunchUrl(appScheme)) {
      await launchUrl(appScheme);
    } else {
      debugPrint('Cannot launch $appScheme');
    }
  }
}
