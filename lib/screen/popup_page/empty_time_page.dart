import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';
import '../../model/weekly_schedule.dart';
import '../../screen/component/app_bar.dart';

class EmptyTimePage extends StatelessWidget {
  final WeeklySchedule schedule;
  int eventId = 0;

  EmptyTimePage({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(
        title: '조회된 공강 시간',
        backButton: true,
      ),
      body: TimetableView(
        laneEventsList: _buildLaneEvents(),
        timetableStyle: TimetableStyle(
          laneWidth: screenWidth * 0.128,
          timeItemHeight: screenHeight * 0.057,
          timeItemWidth: screenWidth * 0.1,
          startHour: 9,
        ),
        onEmptySlotTap: onTimeSlotTappedCallBack,
        onEventTap: (TableEvent event) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  '공통 공강 시간',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '날짜: ${_getDayName(event.laneIndex)}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '시작 시간: ${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '종료 시간: ${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<LaneEvents> _buildLaneEvents() {
    List<LaneEvents> laneEventsList = [];

    laneEventsList.add(_createLaneEvents(schedule.monday, '월', 1));
    laneEventsList.add(_createLaneEvents(schedule.tuesday, '화', 2));
    laneEventsList.add(_createLaneEvents(schedule.wednesday, '수', 3));
    laneEventsList.add(_createLaneEvents(schedule.thursday, '목', 4));
    laneEventsList.add(_createLaneEvents(schedule.friday, '금', 5));
    laneEventsList.add(_createLaneEvents(schedule.saturday, '토', 6));
    laneEventsList.add(_createLaneEvents(schedule.sunday, '일', 7));

    return laneEventsList;
  }

  LaneEvents _createLaneEvents(
      List<TimeSlot> timeSlots, String day, int laneIndex) {
    List<TableEvent> events = timeSlots.map((timeSlot) {
      int startHour = int.parse(timeSlot.startTime.split(':')[0]);
      int startMinute = int.parse(timeSlot.startTime.split(':')[1]);
      int endHour = int.parse(timeSlot.endTime.split(':')[0]);
      int endMinute = int.parse(timeSlot.endTime.split(':')[1]);

      eventId += 1;
      return TableEvent(
        title: ' ',
        startTime: TableEventTime(hour: startHour, minute: startMinute),
        endTime: TableEventTime(hour: endHour, minute: endMinute),
        laneIndex: laneIndex,
        eventId: eventId,
      );
    }).toList();

    return LaneEvents(
      lane: Lane(name: day, laneIndex: laneIndex),
      events: events,
    );
  }

  String _getDayName(int laneIndex) {
    switch (laneIndex) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        throw Exception('Invalid laneIndex: $laneIndex');
    }
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {}
}
