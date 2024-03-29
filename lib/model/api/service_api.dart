import 'dart:async';
import 'dart:convert';

import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/api/token_api_utils.dart';
import 'package:acha/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../api_response.dart';
import '../exception/exception_message.dart';
import '../weekly_schedule.dart';

class ServiceApi extends TokenApiUtils {
  final serviceServerUrl = dotenv.env['SERVICE_SERVER_URL']!;
  Future<void> setTimeTable(String shareUrl, UserProvider userProvider) async {
    String identifier = shareUrl.split('@')[1];
    await checkLoginStatus(userProvider);

    final url =
        Uri.parse('$serviceServerUrl/timetable/save?identifier=$identifier');

    final response = await http
        .get(url, headers: await getHeaders(authRequired: true))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    await isResponseSuccessWithProvider(response, userProvider);
    return;
  }

  Future<List<AlarmInfo>> getAllAlarms(UserProvider userProvider) async {
    await checkLoginStatus(userProvider);
    final url = Uri.parse('$serviceServerUrl/alarm');

    final response = await http
        .get(url, headers: await getHeaders(authRequired: true))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    await isResponseSuccessWithProvider(response, userProvider);

    final json = ApiResponse.fromJson(utf8.decode(response.bodyBytes));
    List<dynamic> data = json.data['alarms'];
    List<AlarmInfo> alarms =
        data.map((item) => AlarmInfo.fromJson(item)).toList();

    return alarms;
  }

  Future<void> saveAlarm(AlarmInfo alarmInfo, UserProvider userProvider) async {
    await checkLoginStatus(userProvider);
    final url = Uri.parse('$serviceServerUrl/alarm/save');

    Map<String, dynamic> body = {
      "subjectId": -1,
      "name": alarmInfo.subjectName,
      "day": alarmInfo.day,
      "hour": alarmInfo.hour,
      "minute": alarmInfo.minute,
      "alarmGap": alarmInfo.alarmGap,
      "isAlarmOn": alarmInfo.isAlarmOn,
    };

    final response = await http
        .post(url,
            headers: await getHeaders(authRequired: true),
            body: jsonEncode(body))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    isResponseSuccessWithProvider(response, userProvider);
  }

  Future<void> updateAlarm(int alarmId, int alarmGap, bool isAlarmOn,
      UserProvider userProvider) async {
    await checkLoginStatus(userProvider);
    final url = Uri.parse('$serviceServerUrl/alarm/update');

    Map<String, dynamic> body = {
      "alarmId": alarmId,
      "alarmGap": alarmGap,
      "isAlarmOn": isAlarmOn,
    };

    final response = await http
        .post(url,
            headers: await getHeaders(authRequired: true),
            body: jsonEncode(body))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    await isResponseSuccessWithProvider(response, userProvider);
  }

  Future<void> deleteOneAlarm(int alarmId, UserProvider userProvider) async {
    await checkLoginStatus(userProvider);
    final url = Uri.parse('$serviceServerUrl/alarm/delete');

    Map<String, dynamic> body = {
      "alarmId": alarmId,
    };

    final response = await http
        .post(url,
            headers: await getHeaders(authRequired: true),
            body: jsonEncode(body))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    await isResponseSuccessWithProvider(response, userProvider);
  }

  Future<void> deleteTimetableAndAlarm(UserProvider userProvider) async {
    await checkLoginStatus(userProvider);
    final url = Uri.parse('$serviceServerUrl/timetable/delete');

    final response = await http
        .post(url, headers: await getHeaders(authRequired: true))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    await isResponseSuccessWithProvider(response, userProvider);
  }

  Future<WeeklySchedule> getWeeklySchedule(
      UserProvider userProvider, List<String> emails) async {
    await checkLoginStatus(userProvider);
    final url = Uri.parse('$serviceServerUrl/timetable/empty-time');

    Map<String, dynamic> body = {
      "emails": emails,
      "minTimeDiff": 60,
      "startTime": 96,
      "endTime": 289
    };

    final response = await http
        .post(url,
            headers: await getHeaders(authRequired: true),
            body: jsonEncode(body))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    await isResponseSuccessWithProvider(response, userProvider);

    debugPrint(utf8.decode(response.bodyBytes));
    final json = ApiResponse.fromJson(utf8.decode(response.bodyBytes));
    return WeeklySchedule.fromMap(json.data);
  }
}
