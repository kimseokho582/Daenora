import 'package:deanora/object/AcademinCalendar.dart';
import 'package:intl/intl.dart';

class Calendar {
  final DateTime date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;
  bool checked;
  String checkedSchdule;

  Calendar(
      {required this.date,
      this.thisMonth = false,
      this.prevMonth = false,
      this.nextMonth = false,
      this.checked = false,
      this.checkedSchdule=""
      });
}

enum StartWeekDay { sunday, monday }

class CustomCalendar {
  // number of days in month [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> _monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  List<Pair> _schdule = schedule.cast<Pair>();
  // 윤년 확인
  bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  List<Calendar> getMonthCalendar(int month, int year,
      {StartWeekDay startWeekDay = StartWeekDay.sunday}) {
    if (year == null || month == null || month < 1 || month > 12)
      throw ArgumentError('Invalid year or month');

    List<Calendar> calendar = [];

    int otherYear;
    int otherMonth;
    int leftDays;
    int totalDays = _monthDays[month - 1];
    if (_isLeapYear(year) && month == DateTime.february) totalDays++;

    for (int i = 0; i < totalDays; i++) {
      calendar.add(
        Calendar(
          date: DateTime(year, month, i + 1),
          thisMonth: true,
        ),
      );
    }

    if ((startWeekDay == StartWeekDay.sunday &&
            calendar.first.date.weekday != DateTime.sunday) ||
        (startWeekDay == StartWeekDay.monday &&
            calendar.first.date.weekday != DateTime.monday)) {
      if (month == DateTime.january) {
        otherMonth = DateTime
            .december; // _monthDays index starts from 0 (11 for december)
        otherYear = year - 1;
      } else {
        otherMonth = month - 1;
        otherYear = year;
      }

      totalDays = _monthDays[otherMonth - 1];
      if (_isLeapYear(otherYear) && otherMonth == DateTime.february)
        totalDays++;

      leftDays = totalDays -
          calendar.first.date.weekday +
          ((startWeekDay == StartWeekDay.sunday) ? 0 : 1);

      for (int i = totalDays; i > leftDays; i--) {
        calendar.insert(
          0,
          Calendar(
            date: DateTime(otherYear, otherMonth, i),
            prevMonth: true,
          ),
        );
      }
    }

    if ((startWeekDay == StartWeekDay.sunday &&
            calendar.last.date.weekday != DateTime.saturday) ||
        (startWeekDay == StartWeekDay.monday &&
            calendar.last.date.weekday != DateTime.sunday)) {
      if (month == DateTime.december) {
        otherMonth = DateTime.january;
        otherYear = year + 1;
      } else {
        otherMonth = month + 1;
        otherYear = year;
      }

      totalDays = _monthDays[otherMonth - 1];
      if (_isLeapYear(otherYear) && otherMonth == DateTime.february)
        totalDays++;

      leftDays = 7 -
          calendar.last.date.weekday -
          ((startWeekDay == StartWeekDay.sunday) ? 1 : 0);
      if (leftDays == -1) leftDays = 6;

      for (int i = 0; i < leftDays; i++) {
        calendar.add(
          Calendar(
            date: DateTime(otherYear, otherMonth, i + 1),
            nextMonth: true,
          ),
        );
      }
    }
    int _rangeX=0, _rangeY=0;
    for (int i = 0; i < _schdule.length; i++) {
      if(DateFormat('yyyy-MM-dd').format(calendar[0].date).toString().compareTo(_schdule[i].schduleDate.substring(0, 10))!=1){
       _rangeX=i;
       break;
      }
    }
    for(int i=_schdule.length-1;i>=0;i--){
      if(DateFormat('yyyy-MM-dd').format(calendar[calendar.length-1].date).toString().compareTo(_schdule[i].schduleDate.substring(0, 10))!=-1){
       _rangeY=i;
       break;
      }
    }

    for (int i = _rangeX; i <= _rangeY; i++) {
      for (int j = 0; j < calendar.length; j++) {
        if (_schdule[i].schduleDate.substring(0, 10) ==
            DateFormat('yyyy-MM-dd').format(calendar[j].date).toString()) {
              calendar[j].checked=true;
              calendar[j].checkedSchdule=_schdule[i].schduleString;
        }
      }
    }

    //print(month);
    //print(calendar[10].date);
    return calendar;
  }
}
