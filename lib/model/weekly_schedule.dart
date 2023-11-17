class TimeSlot {
  final String startTime;
  final String endTime;

  TimeSlot({required this.startTime, required this.endTime});

  factory TimeSlot.fromJson(String str) {
    var times = str
        .replaceFirst('빈 시간대: ', '')
        .split('~')
        .map((e) => e.trim())
        .toList();
    return TimeSlot(startTime: times[0], endTime: times[1]);
  }

  @override
  String toString() {
    return '시작 시간: $startTime, 종료 시간: $endTime';
  }
}

class WeeklySchedule {
  final List<TimeSlot> monday;
  final List<TimeSlot> tuesday;
  final List<TimeSlot> wednesday;
  final List<TimeSlot> thursday;
  final List<TimeSlot> friday;
  final List<TimeSlot> saturday;
  final List<TimeSlot> sunday;

  WeeklySchedule({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WeeklySchedule.fromMap(Map<String, dynamic> map) => WeeklySchedule(
        monday: map['MONDAY'] != null
            ? List<TimeSlot>.from(
                map['MONDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
        tuesday: map['TUESDAY'] != null
            ? List<TimeSlot>.from(
                map['TUESDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
        wednesday: map['WEDNESDAY'] != null
            ? List<TimeSlot>.from(
                map['WEDNESDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
        thursday: map['THURSDAY'] != null
            ? List<TimeSlot>.from(
                map['THURSDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
        friday: map['FRIDAY'] != null
            ? List<TimeSlot>.from(
                map['FRIDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
        saturday: map['SATURDAY'] != null
            ? List<TimeSlot>.from(
                map['SATURDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
        sunday: map['SUNDAY'] != null
            ? List<TimeSlot>.from(
                map['SUNDAY'].map((x) => TimeSlot.fromJson(x)))
            : [],
      );

  @override
  String toString() {
    return '월요일: $monday, 화요일: $tuesday, 수요일: $wednesday, 목요일: $thursday, 금요일: $friday, 토요일: $saturday, 일요일: $sunday';
  }
}
