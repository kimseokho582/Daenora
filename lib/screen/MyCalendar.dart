import 'package:deanora/Widgets/MakeCalendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  List<Calendar> calendar = CustomCalendar()
      .getMonthCalendar(10, 2021, startWeekDay: StartWeekDay.sunday);
  DateTime _currentDateTime =
      DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    print(_currentDateTime);
    print(_selectDateTime);
    //calendar.map((e) => print(e.date)).toList();
    return Container(
      child: Text("여긴 달력"),
    );
  }
}
