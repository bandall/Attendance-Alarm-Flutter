import 'dart:async';
import 'dart:convert';

import 'package:acha/model/alarm/alarm_info.dart';
import 'package:acha/model/api/token_api_utils.dart';
import 'package:acha/provider/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../api_response.dart';
import '../exception/exception_message.dart';

class ServiceApi {
  final baseUrl = dotenv.env['SERVICE_SERVER_URL'];
  final timoutTime = const Duration(seconds: 2);
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final TokenApiUtils tokenApiUtils = TokenApiUtils();

  Future<Map<String, String>> getHeaders({bool authRequired = false}) async {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    if (authRequired) {
      String? accessToken = await _storage.read(key: 'accessToken');
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Future<void> setTimeTable(String shareUrl, UserProvider userProvider) async {
    String identifier = shareUrl.split('@')[1];
    await tokenApiUtils.checkLoginStatus(userProvider);

    final url = Uri.parse('$baseUrl/timetable/save?identifier=$identifier');

    final response = await http
        .get(url, headers: await getHeaders(authRequired: true))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    isResponseSuccess(response);
    return;
  }

  Future<List<AlarmInfo>> getAllAlarms(UserProvider userProvider) async {
    await tokenApiUtils.checkLoginStatus(userProvider);
    final url = Uri.parse('$baseUrl/alarm');

    final response = await http
        .get(url, headers: await getHeaders(authRequired: true))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });
    final json = ApiResponse.fromJson(utf8.decode(response.bodyBytes));

    List<dynamic> data = json.data['alarms'];

    List<AlarmInfo> alarms =
        data.map((item) => AlarmInfo.fromJson(item)).toList();

    return alarms;
  }

  Future<void> updateAlarm(int alarmId, int alarmGap, bool isAlarmOn,
      UserProvider userProvider) async {
    await tokenApiUtils.checkLoginStatus(userProvider);
    final url = Uri.parse('$baseUrl/alarm/update');

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

    isResponseSuccess(response);
  }

  Future<void> deleteTimetableAndAlarm(UserProvider userProvider) async {
    await tokenApiUtils.checkLoginStatus(userProvider);
    final url = Uri.parse('$baseUrl/timetable/delete');

    final response = await http
        .post(url, headers: await getHeaders(authRequired: true))
        .timeout(timoutTime, onTimeout: () {
      throw TimeoutException(ExceptionMessage.SERVER_NOT_RESPONDING);
    });

    isResponseSuccess(response);
  }

  Future<void> isResponseSuccess(http.Response response) async {
    if (response.statusCode == 500) {
      throw Exception(response.body);
    }

    if (response.statusCode != 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(json['data']['errMsg']);
    }
  }
}
