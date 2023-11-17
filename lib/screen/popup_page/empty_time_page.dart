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
    return Scaffold(
      appBar: const CustomAppBar(
        title: '조회된 공강 시간',
        backButton: true,
      ),
      body: TimetableView(
        laneEventsList: _buildLaneEvents(),
        timetableStyle: const TimetableStyle(
            laneWidth: 45, timeItemHeight: 30, timeItemWidth: 65),
        onEmptySlotTap: onTimeSlotTappedCallBack,
        onEventTap: onEventTapCallBack,
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

  void onEventTapCallBack(TableEvent event) {}

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {}
}
