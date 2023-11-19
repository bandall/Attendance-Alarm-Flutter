class AlarmInfo {
  final int alarmId;
  final int memberId;
  final int day;
  final int hour;
  final int minute;
  int alarmGap;
  bool isAlarmOn;
  final int subjectId;
  final String subjectName;

  AlarmInfo(
      {required this.alarmId,
      required this.memberId,
      required this.day,
      required this.hour,
      required this.minute,
      required this.alarmGap,
      required this.isAlarmOn,
      required this.subjectId,
      required this.subjectName});

  factory AlarmInfo.fromJson(Map<String, dynamic> json) {
    return AlarmInfo(
      alarmId: json['alarmId'],
      memberId: json['memberId'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      alarmGap: json['alarmGap'],
      isAlarmOn: json['isAlarmOn'],
      subjectId: json['subjectDto']['subjectId'],
      subjectName: json['subjectDto']['name'],
    );
  }

  factory AlarmInfo.fromDbJson(Map<String, dynamic> json) {
    return AlarmInfo(
      alarmId: json['alarmId'],
      memberId: json['memberId'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      alarmGap: json['alarmGap'],
      isAlarmOn: json['isAlarmOn'] == 1,
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarmId': alarmId,
      'memberId': memberId,
      'day': day,
      'hour': hour,
      'minute': minute,
      'alarmGap': alarmGap,
      'isAlarmOn': isAlarmOn,
      'subjectId': subjectId,
      'subjectName': subjectName,
    };
  }

  @override
  String toString() {
    return 'AlarmInfo { alarmId: $alarmId, memberId: $memberId, day: $day, hour: $hour, minute: $minute, alarmGap: $alarmGap, isAlarmOn: $isAlarmOn, subjectId: $subjectId, subjectName: $subjectName }';
  }
}
